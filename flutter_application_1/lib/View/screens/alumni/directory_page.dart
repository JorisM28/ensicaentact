import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/View/widget/base_layout.dart';
import '/View/widget/filtre_widget.dart';
import '/Model/alumnis.dart';
import 'add_alumni.dart';
import 'alumni_detail_page.dart';
import '/View/screens/admin/admin_validate_page.dart';
import 'alumni_preview.dart';
import '/service_locator.dart';
import '/ViewModel/alumni/directory_view_model.dart';
import '/l10n/app_localizations.dart'; 
import '/Model/data/services/auth_service.dart';
import '/View/theme/colors.dart';

class DirectoryPage extends StatefulWidget {
  final String? initialSearch;
  const DirectoryPage({super.key, this.initialSearch});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> with RouteAware {
  late DirectoryViewModel viewModel;

  Alumnis? _selectedStudent;
  bool _openFilters = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final currentUser = sl<AuthService>().currentUser;

  bool get isAdmin => currentUser!.role == 'admin';

  @override
  void initState() {
    super.initState();
    viewModel = sl<DirectoryViewModel>();
    viewModel.loadAlumnis();
    if (isAdmin) viewModel.loadPendingRequestsCount();

    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      _searchController.text = widget.initialSearch!;
      viewModel.search(widget.initialSearch!);
    }

    viewModel.addListener((){
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    viewModel.loadAlumnis();
    if(isAdmin)viewModel.loadPendingRequestsCount();
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 800;

    return BaseLayout(
      floatingActionButton: isAdmin ? _buildFabStack() : null,
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowDown): () => _changeKeyboardSelection(1),
          const SingleActivator(LogicalKeyboardKey.arrowUp): () => _changeKeyboardSelection(-1),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              _buildTopBar(isWideScreen),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: viewModel.alumnis.isEmpty
                          ? Center(child: Text(traductions.directoryNoResult))
                          : ListView.builder(
                        controller: _scrollController,
                        itemCount: viewModel.alumnis.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => _studentCard(viewModel.alumnis[index], isWideScreen),
                      ),
                    ),
                    if (isWideScreen) ...[
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 2,
                        child: _selectedStudent == null
                            ? _defaultView()
                            : AlumniPreview(alumni: _selectedStudent!),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isWideScreen) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[100],
      child: isWideScreen
          ? Row(
        children: [
          SizedBox(width: 400, child: _searchField()),
          const SizedBox(width: 15),
          _filterToggleButton(),
          if (_openFilters) Expanded(child: _buildFilters()),
        ],
      )
          : Column(
        children: [
          Row(children: [Expanded(child: _searchField()), _filterToggleButton()]),
          if (_openFilters) ...[const SizedBox(height: 15), _buildFilters()],
        ],
      ),
    );
  }

  Widget _searchField() {
    final traductions = AppLocalizations.of(context)!; 
    return TextField(
      controller: _searchController,
      onChanged: (text) => viewModel.search(text),
      decoration: InputDecoration(
        hintText: traductions.directorySearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear),onPressed: () {
                  _searchController.clear();
                  viewModel.search('');
                })
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _filterToggleButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: _openFilters ? AppColors.ensiCyan : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        icon: Icon(_openFilters ? Icons.filter_list_off : Icons.filter_list,
            color: _openFilters ? Colors.white : Colors.grey[700]),
        onPressed: () => setState(() => _openFilters = !_openFilters),
      ),
    );
  }

  Widget _buildFilters() {
    return ZoneFiltres(
      promotionAvailable: viewModel.promosAvailable,
      selectedPromotion: viewModel.selectedPromotions,
      onPromoChanged: (promo, isTicked) => viewModel.togglePromoFilter(promo, isTicked),

      sectorAvailable: viewModel.sectorAvailable,
      sectorFilterSelected: viewModel.selectedSectors,
      onSectorChanged: (sector, isTicked) => viewModel.toggleSectorFilter(sector, isTicked),
      
      internshipCountryAvailable: viewModel.countriesAvailable,
      internshipCountryFilterSelected: viewModel.selectedCountries,
      onInternshipCountryChanged: (country, isTicked) => viewModel.toggleCountryFilter(country, isTicked),
    );
  }

  Widget _studentCard(Alumnis alumni, bool isWideScreen) {
    final isSelected = alumni == _selectedStudent;
    
    void openDetail() {
      if (isWideScreen) {
        setState(() => _selectedStudent = alumni);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlumniDetailPage(
              alumni: alumni, 
              onSave: () {
                viewModel.loadAlumnis();
              }, 
            ),
          ),
        );
      }
    }

    return Card(
      elevation: isSelected ? 5  : 2,
      color: isSelected ? const Color.fromARGB(255, 210, 210, 210).withOpacity(1) : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isSelected ? const BorderSide(color: Color.fromARGB(255, 118, 118, 118), width: 0.5) : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: openDetail,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.ensiCyan,
                radius: 30,
                child: Text(
                  alumni.firstname.isNotEmpty ? alumni.firstname[0] : "?",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: alumni.wholeName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        children: [
                          if (alumni.promotion != 0)
                            TextSpan(
                              text: " - ${alumni.promotion}",
                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (alumni.job.isNotEmpty || alumni.company.isNotEmpty)...[
                      Text("${alumni.job} ${alumni.company.isEmpty || alumni.job.isEmpty  ? "" : "⟶"} ${alumni.company}", style: TextStyle(color: Colors.grey[800])),
                    ],  
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      children: [
                        if (alumni.sector.isNotEmpty)
                          Chip(label: Text(alumni.sector, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.blue[50]),
                        if (alumni.city.isNotEmpty)
                          Chip(avatar: const Icon(Icons.location_on, size: 14), label: Text(alumni.city, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.orange[50]),
                      ],
                    ),
                  ],
                ),
              ),
              
              IconButton(
                icon: const Icon(Icons.visibility, size: 20, color: Colors.blue),
                onPressed: () {
                  if (!isWideScreen) {
                     openDetail();
                  } else {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlumniDetailPage(
                            alumni: alumni, 
                            onSave: () => viewModel.loadAlumnis(),
                          ),
                        ),
                      );
                  }
                },
              ),

              if (isAdmin) 
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeletion(alumni),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
 Widget _buildFabStack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'btn_history',
          backgroundColor: Colors.indigo,
          onPressed: () => _displayHistory(context),
          child: const Icon(Icons.history, color: Colors.white),
        ),
        const SizedBox(width: 15),
        FloatingActionButton(
          backgroundColor: Colors.orange,
          heroTag: 'btn_pending_requests',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminValidationPage())).then((_) {
            viewModel.loadPendingRequestsCount();
            viewModel.loadAlumnis();
          }),
          child: Badge(label: Text('${viewModel.pendingRequestsCount}'), isLabelVisible: viewModel.pendingRequestsCount > 0, child: const Icon(Icons.playlist_add_check, color: Colors.white)),
        ),
        const SizedBox(width: 15),
        FloatingActionButton(heroTag: 'btn_add_alumni', backgroundColor: AppColors.ensiCyan, onPressed: _openAddModal, child: const Icon(Icons.add, color: Colors.white)),
      ],
    );
  }

  Widget _defaultView() {
    final traductions = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.touch_app, size: 80, color: Colors.grey), Text(traductions.directorySelectStudent, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))],
      ),
    );
  }

  void _openAddModal() {
    final traductions = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(traductions.directoryNewAlumniTitle),
        content: SizedBox(width: 500, child: AddAlumniForm(isAdmin: true, onSuccess: () { Navigator.pop(context); viewModel.loadAlumnis(); })),
      ),
    );
  }

  Future<void> _confirmDeletion(Alumnis alumni) async {
    final traductions = AppLocalizations.of(context)!; 
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(traductions.directoryDeleteConfirmTitle),
        content: Text(traductions.directoryDeleteConfirmContent(alumni.wholeName)),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(traductions.no)), TextButton(onPressed: () => Navigator.pop(context, true), child: Text(traductions.yes))],
      ),
    ) ?? false;
    if (confirm) viewModel.deleteAlumni(alumni);
  }

void _displayHistory(BuildContext context) async {
    final traductions = AppLocalizations.of(context)!; 
    await viewModel.loadHistory();
    final logs = viewModel.historyLogs;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.history, color: AppColors.ensiCyan), 
            const SizedBox(width: 10), 
            Text(traductions.directoryHistoryTitle)
          ]
        ),
        content: SizedBox(
          width: 550,
          height: 500,
          child: logs.isEmpty
              ? Center(child: Text(traductions.directoryHistoryEmpty))
              : ListView.separated(
                  itemCount: logs.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final String desc = log['description'] ?? '';
                    final String action = log['action'] ?? '';
                    
                    final bool isDelete = action == 'SUPPRESSION';
                    final bool isUpdate = action == 'MODIFICATION';
                    final bool isAdd = action == 'AJOUT';
                    IconData iconData = Icons.info_outline;
                    Color iconColor = Colors.grey;
                    Color bgColor = Colors.grey[100]!;

                    if (isDelete) {
                      iconData = Icons.delete_forever;
                      iconColor = Colors.red;
                      bgColor = Colors.red[50]!;
                    } else if (isUpdate) {
                      iconData = Icons.edit;
                      iconColor = Colors.blue;
                      bgColor = Colors.blue[50]!;
                    } else if (isAdd) {
                      iconData = Icons.person_add;
                      iconColor = Colors.green;
                      bgColor = Colors.green[50]!;
                    }

                    String alumniName = "${log['prenom_alumni'] ?? ''} ${log['nom_alumni'] ?? ''}".trim();
                    String editorName = "${log['prenom_editeur'] ?? ''} ${log['nom_editeur'] ?? ''}".trim();

                    if (editorName.isEmpty) editorName = "Admin système";

                    if (alumniName.isEmpty && isDelete) {
                       alumniName = desc.replaceAll("Suppression de ", "");
                    } else if (alumniName.isEmpty) {
                       alumniName = traductions.unknownUser; 
                    }

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor: bgColor,
                        child: Icon(iconData, color: iconColor, size: 22),
                      ),
                      title: Text(
                        alumniName, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$action par $editorName le ${log['date_action']}",
                              style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                            ),
                            if (desc.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey[300]!)
                                ),
                                child: Text(
                                  desc,
                                  style: const TextStyle(color: Colors.black87, fontStyle: FontStyle.italic, fontSize: 13),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      isThreeLine: desc.isNotEmpty,
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(traductions.close)
          )
        ],
      ),
    );
  }
  void _changeKeyboardSelection(int direction) {
    final list = viewModel.alumnis;
    if (list.isEmpty) return;
    
    if (_selectedStudent == null) {
      setState(() => _selectedStudent = list.first);
      return;
    }
    
    int currentIndex = list.indexOf(_selectedStudent!);
    if (currentIndex == -1) {
      setState(() => _selectedStudent = list.first);
      return;
    }
    
    int newIndex = currentIndex + direction;
    if (newIndex >= 0 && newIndex < list.length) {
      setState(() => _selectedStudent = list[newIndex]);
      if (_scrollController.hasClients) {
        double targetPosition = newIndex * 90.0;
        _scrollController.animateTo(
          targetPosition > 200 ? targetPosition - 200 : targetPosition,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }
}