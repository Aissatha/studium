import 'package:flutter/material.dart';

import '../widgets/application_card.dart';

class ApplicationsListPage extends StatefulWidget {
  const ApplicationsListPage({super.key});

  @override
  State<ApplicationsListPage> createState() => _ApplicationsListPageState();
}

class _ApplicationsListPageState extends State<ApplicationsListPage> {
  final _searchCtrl = TextEditingController();
  String _selectedFilter = 'Tous';

  final _filters = const ['Tous', 'En attente', 'Acceptée', 'Refusée'];

  final List<ApplicationUiModel> _applications = const [
    ApplicationUiModel(
      id: 1,
      company: 'Google France',
      position: 'Développeur Frontend Senior',
      dateLabel: '15 janvier 2025',
      status: ApplicationStatus.pending,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 2,
      company: 'Microsoft',
      position: 'Ingénieur Logiciel',
      dateLabel: '12 janvier 2025',
      status: ApplicationStatus.accepted,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 3,
      company: 'Amazon',
      position: 'Chef de Produit Digital',
      dateLabel: '10 janvier 2025',
      status: ApplicationStatus.rejected,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 4,
      company: 'Apple',
      position: 'Designer UX/UI',
      dateLabel: '8 janvier 2025',
      status: ApplicationStatus.pending,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 5,
      company: 'Meta',
      position: 'Développeur React Native',
      dateLabel: '5 janvier 2025',
      status: ApplicationStatus.accepted,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 6,
      company: 'Netflix',
      position: 'Analyste de Données',
      dateLabel: '3 janvier 2025',
      status: ApplicationStatus.pending,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 7,
      company: 'Spotify',
      position: 'Ingénieur Backend',
      dateLabel: '1 janvier 2025',
      status: ApplicationStatus.rejected,
      logoUrl: null,
    ),
    ApplicationUiModel(
      id: 8,
      company: 'Airbnb',
      position: 'Product Manager',
      dateLabel: '28 décembre 2024',
      status: ApplicationStatus.accepted,
      logoUrl: null,
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ApplicationUiModel> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _applications.where((a) {
      final matchesSearch = q.isEmpty ||
          a.company.toLowerCase().contains(q) ||
          a.position.toLowerCase().contains(q);

      final matchesFilter = _selectedFilter == 'Tous' ||
          a.status.label == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _TopBar(
        title: 'Candidatures',
        searchController: _searchCtrl,
        filters: _filters,
        selectedFilter: _selectedFilter,
        onSearchChanged: (_) => setState(() {}),
        onClearSearch: () {
          _searchCtrl.clear();
          setState(() {});
        },
        onSelectFilter: (f) => setState(() => _selectedFilter = f),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: items.isEmpty
            ? _EmptyState(
          hasCriteria:
          _searchCtrl.text.trim().isNotEmpty || _selectedFilter != 'Tous',
        )
            : ListView.separated(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => ApplicationCard(
            application: items[i],
            onTap: () {
              // TODO: Navigator.pushNamed(context, Routes.applicationDetails, arguments: items[i].id);
            },
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopBar({
    required this.title,
    required this.searchController,
    required this.filters,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSelectFilter,
  });

  final String title;
  final TextEditingController searchController;
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSelectFilter;

  @override
  Size get preferredSize => const Size.fromHeight(152);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ),

            // Search
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 18, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher une entreprise ou un poste...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: onClearSearch,
                        icon: const Icon(Icons.close,
                            size: 18, color: Color(0xFF9CA3AF)),
                      ),
                  ],
                ),
              ),
            ),

            // Filters
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((f) {
                    final active = f == selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => onSelectFilter(f),
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: active
                                  ? Colors.white
                                  : const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasCriteria});

  final bool hasCriteria;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search,
                  size: 28, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 14),
            const Text(
              'Aucune candidature trouvée',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasCriteria
                  ? 'Essayez de modifier vos critères de recherche'
                  : "Vous n'avez pas encore postulé à des offres d'emploi",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
