import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api/core.dart';
import '../api/model/model.dart';
import '../model/narrow.dart';
import '../model/unreads.dart';
import 'Video/supabaseChannel/Initializer.dart';
import 'icons.dart';
import 'message_list.dart';
import 'store.dart';
import 'text.dart';
import 'theme.dart';
import 'unread_count_badge.dart';

/// Scrollable listing of subscribed streams.
class SubscriptionListPageBody extends StatefulWidget {
  const SubscriptionListPageBody({super.key});

  @override
  State<SubscriptionListPageBody> createState() =>
      _SubscriptionListPageBodyState();
}

class _SubscriptionListPageBodyState extends State<SubscriptionListPageBody>
    with PerAccountStoreAwareStateMixin<SubscriptionListPageBody> {
  Unreads? unreadsModel;

  @override
  void onNewStore() {
    unreadsModel?.removeListener(_modelChanged);
    unreadsModel =
        PerAccountStoreWidget.of(context).unreads..addListener(_modelChanged);
  }

  @override
  void dispose() {
    unreadsModel?.removeListener(_modelChanged);
    super.dispose();
  }

  void _modelChanged() {
    setState(() {
      // The actual state lives in [unreadsModel].
      // This method was called because that just changed.
    });
  }

  void _sortSubs(List<Subscription> list) {
    list.sort((a, b) {
      if (a.isMuted && !b.isMuted) return 1;
      if (!a.isMuted && b.isMuted) return -1;
      // TODO(i18n): add locale-aware sorting
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Design referenced from:
    //   https://www.figma.com/file/1JTNtYo9memgW7vV6d0ygq/Zulip-Mobile?type=design&node-id=171-12359&mode=design&t=4d0vykoYQ0KGpFuu-0

    // This is an initial version with "Pinned" and "Unpinned"
    // sections following behavior in mobile. Recalculating
    // groups and sorting on every `build` here: it performs well
    // enough and not worth optimizing as it will be replaced
    // with a different behavior:
    // TODO: Implement new grouping behavior and design, see discussion at:
    //   https://chat.zulip.org/#narrow/stream/101-design/topic/UI.20redesign.3A.20left.20sidebar/near/1540147

    // TODO: Implement collapsible topics

    // TODO(i18n): localize strings on page
    //   Strings here left unlocalized as they likely will not
    //   exist in the settled design.
    final store = PerAccountStoreWidget.of(context);

    final List<Subscription> pinned = [];
    final List<Subscription> unpinned = [];
    for (final subscription in store.subscriptions.values) {
      if (subscription.pinToTop) {
        pinned.add(subscription);
      } else {
        unpinned.add(subscription);
      }
    }
    _sortSubs(pinned);
    _sortSubs(unpinned);

    return SafeArea(
      // Don't pad the bottom here; we want the list content to do that.
      bottom: false,
      child: CustomScrollView(
        slivers: [
          if (pinned.isEmpty && unpinned.isEmpty) const _NoSubscriptionsItem(),
          if (pinned.isNotEmpty) ...[
            const _SubscriptionListHeader(label: "Pinned"),
            _SubscriptionList(
              unreadsModel: unreadsModel,
              subscriptions: pinned,
            ),
          ],
          if (unpinned.isNotEmpty) ...[
            const _SubscriptionListHeader(label: "Unpinned"),
            _SubscriptionList(
              unreadsModel: unreadsModel,
              subscriptions: unpinned,
            ),
          ],

          // TODO(#188): add button leading to "All Streams" page with ability to subscribe

          // This ensures last item in scrollable can settle in an unobstructed area.
          const SliverSafeArea(
            sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

class _NoSubscriptionsItem extends StatelessWidget {
  const _NoSubscriptionsItem();

  @override
  Widget build(BuildContext context) {
    final designVariables = DesignVariables.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "No channels found",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: designVariables.subscriptionListHeaderText,
            fontSize: 18,
            height: (20 / 18),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionListHeader extends StatelessWidget {
  const _SubscriptionListHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final designVariables = DesignVariables.of(context);

    final line = Expanded(
      child: Divider(color: designVariables.subscriptionListHeaderLine),
    );

    return SliverToBoxAdapter(
      child: ColoredBox(
        color: designVariables.background,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            line,
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: designVariables.subscriptionListHeaderText,
                  fontSize: 14,
                  letterSpacing: proportionalLetterSpacing(
                    context,
                    0.04,
                    baseFontSize: 14,
                  ),
                  height: (16 / 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            line,
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                // Ждём инициализацию Supabase и получение главного виджета
                Widget app = await AppInitializer.initialize();

                // Переход на новый экран с полученным виджетом
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => app,
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: designVariables.subscriptionListHeaderText,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SubscriptionList extends StatelessWidget {
  const _SubscriptionList({
    required this.unreadsModel,
    required this.subscriptions,
  });

  final Unreads? unreadsModel;
  final List<Subscription> subscriptions;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: subscriptions.length,
      itemBuilder: (BuildContext context, int index) {
        final subscription = subscriptions[index];
        final unreadCount = unreadsModel!.countInChannel(subscription.streamId);
        final showMutedUnreadBadge =
            unreadCount == 0 &&
            unreadsModel!.countInChannelNarrow(subscription.streamId) > 0;
        return SubscriptionItem(
          subscription: subscription,
          unreadCount: unreadCount,
          showMutedUnreadBadge: showMutedUnreadBadge,
        );
      },
    );
  }
}

@visibleForTesting
class SubscriptionItem extends StatelessWidget {
  const SubscriptionItem({
    super.key,
    required this.subscription,
    required this.unreadCount,
    required this.showMutedUnreadBadge,
  });

  final Subscription subscription;
  final int unreadCount;
  final bool showMutedUnreadBadge;

  @override
  Widget build(BuildContext context) {
    final designVariables = DesignVariables.of(context);
    final swatch = colorSwatchFor(context, subscription);
    final hasUnreads = (unreadCount > 0);
    final opacity = subscription.isMuted ? 0.55 : 1.0;

    return Material(
      color: designVariables.background,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MessageListPage.buildRoute(
              context: context,
              narrow: ChannelNarrow(subscription.streamId),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Opacity(
                opacity: opacity,
                child: Icon(
                  size: 18,
                  color: swatch.iconOnPlainBackground,
                  iconDataForStream(subscription),
                ),
              ),
            ),
            // if (subscription.videoEnabled == true) ...[
            //   const SizedBox(width: 5),
            //   Icon(Icons.videocam, color: Colors.blue, size: 18),
            // ],
            const SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    style: TextStyle(
                      fontSize: 18,
                      height: (20 / 18),
                      color: designVariables.labelMenuButton,
                    ).merge(
                      weightVariableTextStyle(
                        context,
                        wght: hasUnreads && !subscription.isMuted ? 600 : null,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    subscription.name,
                  ),
                ),
              ),
            ),
            if (hasUnreads) ...[
              const SizedBox(width: 12),
              Opacity(
                opacity: opacity,
                child: UnreadCountBadge(
                  count: unreadCount,
                  backgroundColor: swatch,
                  bold: true,
                ),
              ),
            ] else if (showMutedUnreadBadge) ...[
              const SizedBox(width: 12),
              const MutedUnreadBadge(),
            ],
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
