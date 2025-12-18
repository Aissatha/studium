import 'package:flutter/material.dart';

import '../../../../core/config/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPasswordChange = false;

  final _currentPwdCtrl = TextEditingController();
  final _newPwdCtrl = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF111827)),
            onPressed: () {
              // TODO: edit profile
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomSafe + 90),
        children: [
          const _ProfileHeaderCard(),
          const SizedBox(height: 16),

          // Paramètres du compte
          _SectionCard(
            title: 'Paramètres du compte',
            child: Column(
              children: [
                _MenuItem(
                  iconBg: const Color(0xFFDBEAFE),
                  icon: Icons.settings,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Paramètres généraux',
                  onTap: () {
                    // TODO: go to settings
                    // Navigator.pushNamed(context, Routes.settings);
                  },
                ),
                _MenuItem(
                  iconBg: const Color(0xFFF3E8FF),
                  icon: Icons.manage_search,
                  iconColor: const Color(0xFF7C3AED),
                  title: 'Préférences de recherche',
                  onTap: () {
                    // TODO
                  },
                ),
                _MenuItem(
                  iconBg: const Color(0xFFFFEDD5),
                  icon: Icons.history,
                  iconColor: const Color(0xFFEA580C),
                  title: 'Historique des candidatures',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.applicationsList);
                  },
                ),
                _MenuItem(
                  iconBg: const Color(0xFFDCFCE7),
                  icon: Icons.description,
                  iconColor: const Color(0xFF16A34A),
                  title: 'Documents téléchargés',
                  onTap: () {
                    // TODO
                  },
                ),
                _MenuItem(
                  iconBg: const Color(0xFFFEE2E2),
                  icon: Icons.shield,
                  iconColor: const Color(0xFFDC2626),
                  title: 'Sécurité et mot de passe',
                  onTap: () => setState(() => showPasswordChange = !showPasswordChange),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Documents récents
          _SectionCard(
            title: 'Documents récents',
            trailing: TextButton(
              onPressed: () {
                // TODO: see all documents
              },
              child: const Text('Voir tout'),
            ),
            child: Column(
              children: const [
                _DocTile(
                  iconBg: Color(0xFFFEE2E2),
                  icon: Icons.picture_as_pdf,
                  iconColor: Color(0xFFDC2626),
                  title: 'CV_Marie_Dubois_2024.pdf',
                  subtitle: 'Modifié il y a 2 jours',
                ),
                SizedBox(height: 10),
                _DocTile(
                  iconBg: Color(0xFFDBEAFE),
                  icon: Icons.description,
                  iconColor: Color(0xFF2563EB),
                  title: 'Lettre_Motivation_HEC.docx',
                  subtitle: 'Modifié il y a 1 jour',
                ),
                SizedBox(height: 10),
                _DocTile(
                  iconBg: Color(0xFFDCFCE7),
                  icon: Icons.image,
                  iconColor: Color(0xFF16A34A),
                  title: 'Diplome_Master_Scan.jpg',
                  subtitle: 'Modifié il y a 5 jours',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats
          _SectionCard(
            title: 'Statistiques',
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: const [
                _StatCard(
                  value: '12',
                  label: 'Candidatures totales',
                  bg: Color(0xFFEFF6FF),
                  fg: Color(0xFF2563EB),
                ),
                _StatCard(
                  value: '3',
                  label: 'Acceptées',
                  bg: Color(0xFFECFDF5),
                  fg: Color(0xFF16A34A),
                ),
                _StatCard(
                  value: '5',
                  label: 'En attente',
                  bg: Color(0xFFFFF7ED),
                  fg: Color(0xFFEA580C),
                ),
                _StatCard(
                  value: '8',
                  label: 'Documents',
                  bg: Color(0xFFF5F3FF),
                  fg: Color(0xFF7C3AED),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Actions rapides
          _SectionCard(
            title: 'Actions rapides',
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _QuickAction(
                  bg: const Color(0xFFEFF6FF),
                  circle: const Color(0xFF2563EB),
                  icon: Icons.edit,
                  label: 'Modifier profil',
                  onTap: () {},
                ),
                _QuickAction(
                  bg: const Color(0xFFECFDF5),
                  circle: const Color(0xFF16A34A),
                  icon: Icons.upload,
                  label: 'Télécharger doc',
                  onTap: () {},
                ),
                _QuickAction(
                  bg: const Color(0xFFF5F3FF),
                  circle: const Color(0xFF7C3AED),
                  icon: Icons.notifications,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _QuickAction(
                  bg: const Color(0xFFFFF7ED),
                  circle: const Color(0xFFEA580C),
                  icon: Icons.help_outline,
                  label: 'Support',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Sécurité (toggle)
          if (showPasswordChange) ...[
            _SectionCard(
              title: 'Sécurité',
              child: Column(
                children: [
                  _LabeledField(label: 'Mot de passe actuel', controller: _currentPwdCtrl),
                  const SizedBox(height: 12),
                  _LabeledField(label: 'Nouveau mot de passe', controller: _newPwdCtrl),
                  const SizedBox(height: 12),
                  _LabeledField(label: 'Confirmer le mot de passe', controller: _confirmPwdCtrl),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: update password
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text('Mettre à jour', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => showPasswordChange = false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF111827),
                            backgroundColor: const Color(0xFFF3F4F6),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Annuler', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ],
      ),

      // Bottom Nav (simple, compatible)
      bottomNavigationBar: _BottomNav(
        currentIndex: 4, // Profil
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.pushNamed(context, Routes.applicationsList); // adapte si tu as home
              break;
            case 2:
              Navigator.pushNamed(context, Routes.applicationsList);
              break;
            case 3:
              Navigator.pushNamed(context, Routes.conversations);
              break;
            case 4:
            // déjà là
              break;
          }
        },
      ),
    );
  }
}

/* ---------------- UI Widgets ---------------- */

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
            ),
          ),
          Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
                  color: Colors.white10,
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person, color: Colors.white, size: 44),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Marie Dubois', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const _HeaderLine(icon: Icons.email, text: 'marie.dubois@email.com'),
              const SizedBox(height: 6),
              const _HeaderLine(icon: Icons.phone, text: '+33 6 12 34 56 78'),
              const SizedBox(height: 14),
              const _ProgressRow(progress: 0.75),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _HeaderLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFFBFDBFE), size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Color(0xFFBFDBFE), fontSize: 12.5)),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final double progress;
  const _ProgressRow({required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Column(
      children: [
        Row(
          children: [
            const Text('Profil complété', style: TextStyle(color: Colors.white, fontSize: 12)),
            const Spacer(),
            Text('$pct%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFF60A5FA),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _DocTile({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF111827), fontSize: 13)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: download/open doc
            },
            icon: const Icon(Icons.download, color: Color(0xFF9CA3AF)),
          )
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color fg;

  const _StatCard({required this.value, required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: fg)),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final Color bg;
  final Color circle;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.bg,
    required this.circle,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: circle, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF111827), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _LabeledField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF374151), fontSize: 12.5)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: const Color(0xFF9CA3AF),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Candidatures'),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
