import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JitsiMeetPage extends StatefulWidget {
  const JitsiMeetPage({super.key});

  @override
  _JitsiMeetPageState createState() => _JitsiMeetPageState();
}

class _JitsiMeetPageState extends State<JitsiMeetPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final JitsiMeet _jitsiMeet = JitsiMeet(); // Создаем экземпляр JitsiMeet

  @override
  void initState() {
    super.initState();
    _joinMeeting();
  }

  Future<void> _joinMeeting() async {
    try {
      // Получаем данные канала из Supabase
      final response = await _supabase
          .from('channel')
          .select('id, meeting_url, organizer_id')
          .order('id', ascending: false)
          .limit(1)
          .single();

      if (response != null && response['meeting_url'] != null) {
        String meetingUrl = response['meeting_url'] as String; // Приводим к String
        int channelId = response['id'] as int; // Приводим к int

        if (meetingUrl.isNotEmpty) {
          // Приводим organizer_id к String? (может быть null)
          String? organizerId = response['organizer_id'] as String?;

          // Если организатор не назначен, присваиваем текущего пользователя как организатора
          if (organizerId == null) {
            final user = await Supabase.instance.client.auth.currentUser;
            if (user != null) {
              // Обновляем поле organizer_id в таблице channel
              await _supabase.from('channel').update({
                'organizer_id': user.id, // Назначаем организатора
              }).eq('id', channelId);

              // Назначаем пользователя организатором
              organizerId = user.id;
            }
          }

          // Теперь проверим роль текущего пользователя, чтобы указать, что он организатор
          final currentUser = await Supabase.instance.client.auth.currentUser;
          bool isOrganizer = currentUser?.id == organizerId;

          // Создаем объект с настройками конференции
          var options = JitsiMeetConferenceOptions(
            room: meetingUrl, // Название комнаты (meeting_url)
            configOverrides: {
              "startWithAudioMuted": false, // Звук включен
              "startWithVideoMuted": false, // Видео включено
              "subject": "Видеозвонок",
              "prejoinPageEnabled": false, // Убираем экран предварительных настроек!
              "disableInviteFunctions": true, // Отключаем возможность приглашений
              "isOrganizer": isOrganizer, // Указываем, что это организатор
            },
          );

          // Подключаемся к звонку
          await _jitsiMeet.join(options);
        }
      }
    } catch (e) {
      debugPrint('Ошибка при подключении к встрече: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
