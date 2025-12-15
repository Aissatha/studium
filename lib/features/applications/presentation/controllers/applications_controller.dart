import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/network/storage_service.dart';
import '../../domain/models/application_draft.dart';

final applicationsControllerProvider =
StateNotifierProvider<ApplicationsController, ApplicationDraft>(
      (ref) => ApplicationsController(Supabase.instance.client),
);

class ApplicationsController extends StateNotifier<ApplicationDraft> {
  ApplicationsController(this._client) : super(ApplicationDraft());

  final SupabaseClient _client;

  // --------- setters ----------
  void setField({required String key, required dynamic value}) {
    switch (key) {
      case 'firstName':
        state = state.copyWith(firstName: value as String);
        break;
      case 'lastName':
        state = state.copyWith(lastName: value as String);
        break;
      case 'birthDate':
        state = state.copyWith(birthDate: value as DateTime?);
        break;
      case 'email':
        state = state.copyWith(email: value as String);
        break;
      case 'phone':
        state = state.copyWith(phone: value as String);
        break;
      case 'address':
        state = state.copyWith(address: value as String);
        break;
      case 'city':
        state = state.copyWith(city: value as String);
        break;
      case 'postalCode':
        state = state.copyWith(postalCode: value as String);
        break;
      case 'country':
        state = state.copyWith(country: value as String);
        break;
      case 'nationality':
        state = state.copyWith(nationality: value as String);
        break;

      case 'lastDegree':
        state = state.copyWith(lastDegree: value as String);
        break;
      case 'institution':
        state = state.copyWith(institution: value as String);
        break;
      case 'graduationYear':
        state = state.copyWith(graduationYear: value as String);
        break;
      case 'gpa':
        state = state.copyWith(gpa: value as String);
        break;

      case 'motivationLetter':
        state = state.copyWith(motivationLetter: value as String);
        break;

      default:
        break;
    }
  }

  void setFile({required String key, File? file}) {
    switch (key) {
      case 'profilePhoto':
        state = file == null
            ? state.copyWith(clearProfilePhoto: true)
            : state.copyWith(profilePhoto: file);
        break;
      case 'cv':
        state = file == null ? state.copyWith(clearCv: true) : state.copyWith(cv: file);
        break;
      case 'transcripts':
        state = file == null
            ? state.copyWith(clearTranscripts: true)
            : state.copyWith(transcripts: file);
        break;
      case 'recommendationLetters':
        state = file == null
            ? state.copyWith(clearRecommendationLetters: true)
            : state.copyWith(recommendationLetters: file);
        break;
      default:
        break;
    }
  }

  void addDegree() {
    final list = [...state.additionalDegrees, DegreeItem()];
    state = state.copyWith(additionalDegrees: list);
  }

  void updateDegree(int index, DegreeItem item) {
    final list = [...state.additionalDegrees];
    list[index] = item;
    state = state.copyWith(additionalDegrees: list);
  }

  void addExperience() {
    final list = [...state.experiences, ExperienceItem()];
    state = state.copyWith(experiences: list);
  }

  void updateExperience(int index, ExperienceItem item) {
    final list = [...state.experiences];
    list[index] = item;
    state = state.copyWith(experiences: list);
  }

  // --------- computed ----------
  int wordCount() {
    final txt = state.motivationLetter.trim();
    if (txt.isEmpty) return 0;
    return txt.split(RegExp(r'\s+')).where((w) => w.trim().isNotEmpty).length;
  }

  int progressPercent() {
    const total = 15;
    var filled = 0;

    if (state.firstName.isNotEmpty) filled++;
    if (state.lastName.isNotEmpty) filled++;
    if (state.birthDate != null) filled++;
    if (state.email.isNotEmpty) filled++;
    if (state.phone.isNotEmpty) filled++;
    if (state.nationality.isNotEmpty) filled++;

    if (state.lastDegree.isNotEmpty) filled++;
    if (state.institution.isNotEmpty) filled++;
    if (state.graduationYear.isNotEmpty) filled++;

    if (state.motivationLetter.isNotEmpty) filled++;

    if (state.cv != null) filled++;
    if (state.transcripts != null) filled++;

    final pct = (filled / total) * 100;
    return pct.round().clamp(0, 100);
  }

  List<String> validate() {
    final errors = <String>[];

    if (state.firstName.isEmpty) errors.add('Prénom');
    if (state.lastName.isEmpty) errors.add('Nom');
    if (state.birthDate == null) errors.add('Date de naissance');
    if (state.email.isEmpty) errors.add('Email');
    if (state.phone.isEmpty) errors.add('Téléphone');
    if (state.nationality.isEmpty) errors.add('Nationalité');

    if (state.lastDegree.isEmpty) errors.add('Dernier diplôme');
    if (state.institution.isEmpty) errors.add('Établissement');
    if (state.graduationYear.isEmpty) errors.add("Année d'obtention");

    if (wordCount() < 300) errors.add('Lettre de motivation (minimum 300 mots)');

    if (state.cv == null) errors.add('CV');
    if (state.transcripts == null) errors.add('Relevés de notes');

    return errors;
  }

  // --------- save / submit ----------
  Future<void> saveDraft() async {
    // Tu peux persister en local (Hive/SharedPrefs) ou dans Supabase.
    // Pour l’instant: placeholder.
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  Future<void> submit({
    required String bucket,
    required String applicationId,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not authenticated');

    // Upload docs (si présents)
    final storage = StorageService(_client);

    String? cvUrl;
    if (state.cv != null) {
      cvUrl = await storage.uploadUserDoc(
        bucket: bucket,
        path: '$uid/applications/$applicationId/cv${_ext(state.cv!)}',
        file: state.cv!,
        contentType: _contentType(state.cv!),
      );
    }

    String? transcriptsUrl;
    if (state.transcripts != null) {
      transcriptsUrl = await storage.uploadUserDoc(
        bucket: bucket,
        path: '$uid/applications/$applicationId/transcripts${_ext(state.transcripts!)}',
        file: state.transcripts!,
        contentType: _contentType(state.transcripts!),
      );
    }

    String? recoUrl;
    if (state.recommendationLetters != null) {
      recoUrl = await storage.uploadUserDoc(
        bucket: bucket,
        path: '$uid/applications/$applicationId/recommendations${_ext(state.recommendationLetters!)}',
        file: state.recommendationLetters!,
        contentType: _contentType(state.recommendationLetters!),
      );
    }

    // Ici tu feras l’insert dans ta table applications + application_profile etc.
    // Exemple minimal: insert “applications”.
    await _client.from('applications').insert({
      'id': applicationId,
      'user_id': uid,
      'first_name': state.firstName,
      'last_name': state.lastName,
      'birth_date': state.birthDate?.toIso8601String(),
      'email': state.email,
      'phone': state.phone,
      'address': state.address,
      'city': state.city,
      'postal_code': state.postalCode,
      'country': state.country,
      'nationality': state.nationality,
      'last_degree': state.lastDegree,
      'institution': state.institution,
      'graduation_year': state.graduationYear,
      'gpa': state.gpa,
      'motivation_letter': state.motivationLetter,
      'cv_url': cvUrl,
      'transcripts_url': transcriptsUrl,
      'recommendations_url': recoUrl,
      'status': 'submitted',
    });
  }

  String _ext(File f) {
    final name = f.path.toLowerCase();
    final dot = name.lastIndexOf('.');
    if (dot == -1) return '';
    return name.substring(dot);
  }

  String? _contentType(File f) {
    final p = f.path.toLowerCase();
    if (p.endsWith('.pdf')) return 'application/pdf';
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.jpg') || p.endsWith('.jpeg')) return 'image/jpeg';
    if (p.endsWith('.doc')) return 'application/msword';
    if (p.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    return null;
  }
}
