import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/applications_controller.dart';
import '../../domain/models/application_draft.dart';

class NewApplicationPage extends ConsumerStatefulWidget {
  const NewApplicationPage({super.key});

  @override
  ConsumerState<NewApplicationPage> createState() => _NewApplicationPageState();
}

class _NewApplicationPageState extends ConsumerState<NewApplicationPage> {
  int currentSection = 0;
  bool showSaveToast = false;
  bool showErrorToast = false;
  List<String> validationErrors = [];

  final sections = const [
    'Informations personnelles',
    'Parcours académique',
    'Expérience professionnelle',
    'Motivation',
    'Documents',
  ];

  ApplicationsController get c => ref.read(applicationsControllerProvider.notifier);
  ApplicationDraft get s => ref.watch(applicationsControllerProvider);

  Future<File?> _pickFile({required List<String> allowedExtensions}) async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: false,
    );
    if (res == null || res.files.isEmpty) return null;
    final path = res.files.single.path;
    if (path == null) return null;
    return File(path);
  }

  Future<void> _pickProfilePhoto() async {
    final f = await _pickFile(allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (f != null) c.setFile(key: 'profilePhoto', file: f);
  }

  Future<void> _pickDoc(String key) async {
    final f = await _pickFile(allowedExtensions: ['pdf', 'doc', 'docx']);
    if (f != null) c.setFile(key: key, file: f);
  }

  void _toast({required bool ok, required String title, String? subtitle}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ok ? Colors.green.shade700 : Colors.red.shade700,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            if (subtitle != null) Text(subtitle),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> onSave() async {
    await c.saveDraft();
    setState(() => showSaveToast = true);
    _toast(ok: true, title: 'Candidature sauvegardée');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mounted) setState(() => showSaveToast = false);
  }

  Future<void> onSubmit() async {
    final errors = c.validate();
    if (errors.isNotEmpty) {
      setState(() {
        validationErrors = errors;
        showErrorToast = true;
      });
      _toast(
        ok: false,
        title: 'Veuillez compléter tous les champs requis',
        subtitle: errors.map((e) => '• $e').join('\n'),
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (mounted) setState(() => showErrorToast = false);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ConfirmDialog(
        fullName: '${s.firstName} ${s.lastName}',
        hasReco: s.recommendationLetters != null,
      ),
    );

    if (confirmed != true) return;

    // ⚠️ bucket + applicationId
    // applicationId: à générer côté app ou côté DB (uuid). Ici: timestamp simple (à remplacer par uuid).
    final appId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await c.submit(bucket: 'user-docs', applicationId: appId);
      if (!mounted) return;
      _toast(ok: true, title: 'Soumission envoyée ✅');
      Navigator.of(context).pop(); // retour
    } catch (e) {
      if (!mounted) return;
      _toast(ok: false, title: 'Erreur soumission', subtitle: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = c.progressPercent();
    final wc = c.wordCount();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Nouvelle candidature'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: pct / 100,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$pct%', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE6E6EE))),
            boxShadow: [BoxShadow(blurRadius: 10, offset: Offset(0, -2), color: Color(0x1A000000))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 4, backgroundColor: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text('Progression : $pct%', style: const TextStyle(color: Colors.black54)),
                  const Spacer(),
                  Text('Section ${currentSection + 1}/${sections.length}',
                      style: const TextStyle(color: Colors.black45, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSave,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Sauvegarder'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSubmit,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Soumettre'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _ProgramCard(),
          const SizedBox(height: 12),
          _SectionChips(
            sections: sections,
            current: currentSection,
            onTap: (i) => setState(() => currentSection = i),
          ),
          const SizedBox(height: 12),

          if (currentSection == 0) _PersonalSection(
            state: s,
            onChanged: (k, v) => c.setField(key: k, value: v),
            onPickPhoto: _pickProfilePhoto,
            onClearPhoto: () => c.setFile(key: 'profilePhoto', file: null),
          ),

          if (currentSection == 1) _AcademicSection(
            state: s,
            onChanged: (k, v) => c.setField(key: k, value: v),
            onAddDegree: c.addDegree,
            onUpdateDegree: c.updateDegree,
          ),

          if (currentSection == 2) _ExperienceSection(
            state: s,
            onAddExperience: c.addExperience,
            onUpdateExperience: c.updateExperience,
          ),

          if (currentSection == 3) _MotivationSection(
            value: s.motivationLetter,
            wordCount: wc,
            onChanged: (v) => c.setField(key: 'motivationLetter', value: v),
          ),

          if (currentSection == 4) _DocumentsSection(
            state: s,
            onPick: _pickDoc,
            onClear: (k) => c.setFile(key: k, file: null),
          ),
        ],
      ),
    );
  }
}

/* ---------------- UI widgets (local, simple, mobile-first) ---------------- */

class _ProgramCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAF2)),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x0F000000), offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.school_rounded),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Master en Sciences Cognitives',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                SizedBox(height: 2),
                Text('Université de la Sorbonne', style: TextStyle(color: Colors.black54)),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Tag('2 ans'),
                    _Tag('Français'),
                    _Tag('€8,000/an'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _SectionChips extends StatelessWidget {
  const _SectionChips({
    required this.sections,
    required this.current,
    required this.onTap,
  });

  final List<String> sections;
  final int current;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(sections.length, (i) {
            final active = i == current;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: active,
                label: Text(sections[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : Colors.black54)),
                selectedColor: const Color(0xFF2563EB),
                onSelected: (_) => onTap(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/* ---------------- Sections ---------------- */

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PersonalSection extends StatelessWidget {
  const _PersonalSection({
    required this.state,
    required this.onChanged,
    required this.onPickPhoto,
    required this.onClearPhoto,
  });

  final ApplicationDraft state;
  final void Function(String key, dynamic value) onChanged;
  final Future<void> Function() onPickPhoto;
  final VoidCallback onClearPhoto;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return _Card(
      title: 'Informations personnelles',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _tf(label: 'Prénom *', value: state.firstName, onChanged: (v) => onChanged('firstName', v))),
              const SizedBox(width: 12),
              Expanded(child: _tf(label: 'Nom *', value: state.lastName, onChanged: (v) => onChanged('lastName', v))),
            ],
          ),
          const SizedBox(height: 12),
          _dateField(
            context,
            label: 'Date de naissance *',
            value: state.birthDate == null ? '' : df.format(state.birthDate!),
            onPick: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(now.year - 80),
                lastDate: DateTime(now.year - 10),
                initialDate: state.birthDate ?? DateTime(now.year - 18),
              );
              if (picked != null) onChanged('birthDate', picked);
            },
          ),
          const SizedBox(height: 12),
          _tf(label: 'Email *', value: state.email, keyboardType: TextInputType.emailAddress, onChanged: (v) => onChanged('email', v)),
          const SizedBox(height: 12),
          _tf(label: 'Téléphone *', value: state.phone, keyboardType: TextInputType.phone, onChanged: (v) => onChanged('phone', v)),
          const SizedBox(height: 12),
          _tf(label: 'Adresse complète', value: state.address, onChanged: (v) => onChanged('address', v)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _tf(label: 'Ville', value: state.city, onChanged: (v) => onChanged('city', v))),
              const SizedBox(width: 12),
              Expanded(child: _tf(label: 'Code postal', value: state.postalCode, onChanged: (v) => onChanged('postalCode', v))),
            ],
          ),
          const SizedBox(height: 12),
          _tf(label: 'Nationalité *', value: state.nationality, onChanged: (v) => onChanged('nationality', v)),
          const SizedBox(height: 16),
          _fileBox(
            title: 'Photo de profil',
            subtitle: 'Formats: JPG, PNG',
            file: state.profilePhoto,
            onPick: onPickPhoto,
            onClear: onClearPhoto,
          ),
        ],
      ),
    );
  }

  Widget _tf({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _dateField(BuildContext context, {required String label, required String value, required Future<void> Function() onPick}) {
    return InkWell(
      onTap: onPick,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value.isEmpty ? 'Sélectionner...' : value)),
            const Icon(Icons.calendar_month_rounded),
          ],
        ),
      ),
    );
  }

  Widget _fileBox({
    required String title,
    required String subtitle,
    required File? file,
    required Future<void> Function() onPick,
    required VoidCallback onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6D6E0), style: BorderStyle.solid),
        color: const Color(0xFFFAFAFC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 10),
          if (file == null)
            ElevatedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Choisir un fichier'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )
          else
            Row(
              children: [
                Expanded(child: Text(file.path.split('/').last, style: const TextStyle(fontWeight: FontWeight.w600))),
                IconButton(onPressed: onClear, icon: const Icon(Icons.close_rounded)),
              ],
            ),
        ],
      ),
    );
  }
}

class _AcademicSection extends StatelessWidget {
  const _AcademicSection({
    required this.state,
    required this.onChanged,
    required this.onAddDegree,
    required this.onUpdateDegree,
  });

  final ApplicationDraft state;
  final void Function(String key, dynamic value) onChanged;
  final VoidCallback onAddDegree;
  final void Function(int index, DegreeItem item) onUpdateDegree;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Parcours académique',
      child: Column(
        children: [
          _tf('Dernier diplôme obtenu *', state.lastDegree, (v) => onChanged('lastDegree', v)),
          const SizedBox(height: 12),
          _tf('Établissement *', state.institution, (v) => onChanged('institution', v)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _tf("Année d'obtention *", state.graduationYear, (v) => onChanged('graduationYear', v), keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _tf('Moyenne générale', state.gpa, (v) => onChanged('gpa', v))),
            ],
          ),
          const SizedBox(height: 16),

          for (int i = 0; i < state.additionalDegrees.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6E6EE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diplôme supplémentaire #${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _tf('Diplôme', state.additionalDegrees[i].degree, (v) {
                          final item = state.additionalDegrees[i]..degree = v;
                          onUpdateDegree(i, item);
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _tf('Établissement', state.additionalDegrees[i].institution, (v) {
                          final item = state.additionalDegrees[i]..institution = v;
                          onUpdateDegree(i, item);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          OutlinedButton.icon(
            onPressed: onAddDegree,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un autre diplôme'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tf(String label, String value, ValueChanged<String> onChanged, {TextInputType? keyboardType}) {
    return TextField(
      controller: TextEditingController(text: value),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({
    required this.state,
    required this.onAddExperience,
    required this.onUpdateExperience,
  });

  final ApplicationDraft state;
  final VoidCallback onAddExperience;
  final void Function(int index, ExperienceItem item) onUpdateExperience;

  @override
  Widget build(BuildContext context) {
    if (state.experiences.isEmpty) {
      return _Card(
        title: 'Expérience professionnelle',
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Icon(Icons.work_outline_rounded, size: 42, color: Colors.black26),
            const SizedBox(height: 8),
            const Text('Aucune expérience ajoutée', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onAddExperience,
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text('Ajouter votre première expérience'),
              ),
            ),
          ],
        ),
      );
    }

    return _Card(
      title: 'Expérience professionnelle',
      child: Column(
        children: [
          for (int i = 0; i < state.experiences.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6E6EE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expérience #${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _tf('Entreprise', state.experiences[i].company, (v) {
                    final item = state.experiences[i]..company = v;
                    onUpdateExperience(i, item);
                  }),
                  const SizedBox(height: 12),
                  _tf('Poste', state.experiences[i].position, (v) {
                    final item = state.experiences[i]..position = v;
                    onUpdateExperience(i, item);
                  }),
                  const SizedBox(height: 12),
                  _tf('Description', state.experiences[i].description, (v) {
                    final item = state.experiences[i]..description = v;
                    onUpdateExperience(i, item);
                  }, maxLines: 3),
                ],
              ),
            ),

          OutlinedButton.icon(
            onPressed: onAddExperience,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une autre expérience'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tf(String label, String value, ValueChanged<String> onChanged, {int maxLines = 1}) {
    return TextField(
      controller: TextEditingController(text: value),
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

class _MotivationSection extends StatelessWidget {
  const _MotivationSection({
    required this.value,
    required this.wordCount,
    required this.onChanged,
  });

  final String value;
  final int wordCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final remaining = (300 - wordCount).clamp(0, 300);
    final ok = wordCount >= 300;

    return _Card(
      title: 'Lettre de motivation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Conseils de rédaction', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text('• Pourquoi ce programme vous intéresse\n• Vos objectifs de carrière\n• Vos compétences pertinentes\n• Votre engagement',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Votre lettre *', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$wordCount mots', style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            maxLines: 10,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Madame, Monsieur,\n\nJe vous écris pour exprimer mon vif intérêt...',
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Minimum recommandé : 300 mots', style: TextStyle(fontSize: 12, color: Colors.black45)),
              const Spacer(),
              Text(
                ok ? '✓ Longueur appropriée' : '$remaining mots restants',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ok ? Colors.green.shade700 : Colors.orange.shade700),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({
    required this.state,
    required this.onPick,
    required this.onClear,
  });

  final ApplicationDraft state;
  final Future<void> Function(String key) onPick;
  final void Function(String key) onClear;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Documents requis',
      child: Column(
        children: [
          _docBox(
            title: 'CV (PDF/DOC) *',
            subtitle: 'Taille max recommandée : 5MB',
            file: state.cv,
            onPick: () => onPick('cv'),
            onClear: () => onClear('cv'),
          ),
          const SizedBox(height: 12),
          _docBox(
            title: 'Relevés de notes *',
            subtitle: 'Taille max recommandée : 10MB',
            file: state.transcripts,
            onPick: () => onPick('transcripts'),
            onClear: () => onClear('transcripts'),
          ),
          const SizedBox(height: 12),
          _docBox(
            title: 'Lettres de recommandation',
            subtitle: 'Optionnel',
            file: state.recommendationLetters,
            onPick: () => onPick('recommendationLetters'),
            onClear: () => onClear('recommendationLetters'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(14)),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.deepOrange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '• Documents en français ou anglais\n• Traductions certifiées acceptées\n• Vérifiez la qualité des scans avant upload',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _docBox({
    required String title,
    required String subtitle,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6E6EE)),
        color: const Color(0xFFFAFAFC),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 10),
          if (file == null)
            ElevatedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Choisir un fichier'),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )
          else
            Row(
              children: [
                Expanded(child: Text(file.path.split('/').last, style: const TextStyle(fontWeight: FontWeight.w600))),
                IconButton(onPressed: onClear, icon: const Icon(Icons.close_rounded)),
              ],
            ),
        ],
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({required this.fullName, required this.hasReco});
  final String fullName;
  final bool hasReco;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmer la soumission'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Candidat : $fullName'),
          const SizedBox(height: 8),
          const Text('Programme : Master en Sciences Cognitives'),
          const SizedBox(height: 10),
          const Text('Documents :', style: TextStyle(fontWeight: FontWeight.w700)),
          const Text('• CV'),
          const Text('• Relevés de notes'),
          if (hasReco) const Text('• Lettres de recommandation'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirmer l'envoi")),
      ],
    );
  }
}
