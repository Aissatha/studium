import 'dart:io';

class DegreeItem {
  DegreeItem({
    this.degree = '',
    this.institution = '',
    this.year = '',
    this.gpa = '',
  });

  String degree;
  String institution;
  String year;
  String gpa;
}

class ExperienceItem {
  ExperienceItem({
    this.company = '',
    this.position = '',
    this.startDate,
    this.endDate,
    this.description = '',
  });

  String company;
  String position;
  DateTime? startDate;
  DateTime? endDate;
  String description;
}

class ApplicationDraft {
  ApplicationDraft({
    // Perso
    this.firstName = '',
    this.lastName = '',
    this.birthDate,
    this.email = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.postalCode = '',
    this.country = '',
    this.nationality = '',
    this.profilePhoto,

    // Académique
    this.lastDegree = '',
    this.institution = '',
    this.graduationYear = '',
    this.gpa = '',
    this.additionalDegrees = const [],

    // Pro
    this.experiences = const [],

    // Motivation
    this.motivationLetter = '',

    // Docs
    this.cv,
    this.transcripts,
    this.recommendationLetters,
  });

  // Perso
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String nationality;
  final File? profilePhoto;

  // Académique
  final String lastDegree;
  final String institution;
  final String graduationYear;
  final String gpa;
  final List<DegreeItem> additionalDegrees;

  // Pro
  final List<ExperienceItem> experiences;

  // Motivation
  final String motivationLetter;

  // Docs
  final File? cv;
  final File? transcripts;
  final File? recommendationLetters;

  ApplicationDraft copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    String? nationality,
    File? profilePhoto,
    bool clearProfilePhoto = false,

    String? lastDegree,
    String? institution,
    String? graduationYear,
    String? gpa,
    List<DegreeItem>? additionalDegrees,

    List<ExperienceItem>? experiences,

    String? motivationLetter,

    File? cv,
    bool clearCv = false,
    File? transcripts,
    bool clearTranscripts = false,
    File? recommendationLetters,
    bool clearRecommendationLetters = false,
  }) {
    return ApplicationDraft(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      nationality: nationality ?? this.nationality,
      profilePhoto: clearProfilePhoto ? null : (profilePhoto ?? this.profilePhoto),

      lastDegree: lastDegree ?? this.lastDegree,
      institution: institution ?? this.institution,
      graduationYear: graduationYear ?? this.graduationYear,
      gpa: gpa ?? this.gpa,
      additionalDegrees: additionalDegrees ?? this.additionalDegrees,

      experiences: experiences ?? this.experiences,

      motivationLetter: motivationLetter ?? this.motivationLetter,

      cv: clearCv ? null : (cv ?? this.cv),
      transcripts: clearTranscripts ? null : (transcripts ?? this.transcripts),
      recommendationLetters: clearRecommendationLetters ? null : (recommendationLetters ?? this.recommendationLetters),
    );
  }
}
