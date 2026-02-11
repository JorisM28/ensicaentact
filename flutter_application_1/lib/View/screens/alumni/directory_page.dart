import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/profile_badge.dart';
import '../../../Model/core/theme/colors.dart';
import '../../../Model/alumnis.dart';
import '../../../Model/data/services/database_service.dart';
import '../../common/filtre_widget.dart';
import 'add_alumni.dart';
import 'add_alumni_form.dart';
import 'alumni_detail_page.dart';
import '../admin/admin_validate_page.dart';
import 'alumni_preview.dart';
import '../../navigation.dart';
import '../../../ViewModel/alumni/directory_viewmodel.dart';

class DirectoryPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const DirectoryPage({super.key, required this.user});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> with RouteAware {
  late DirectoryViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DirectoryViewModel(user: widget.user);
    viewModel.loadInitialData();
    viewModel.loadCounterNotifications();
    viewModel.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    viewModel.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    viewModel.loadInitialData();
    viewModel.loadCounterNotifications();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text("ENSIcaentact (${widget.user['role']})"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          if (viewModel.isAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => _displayHistory(context),
            ),
          ProfileBadge(user: widget.user),
        ],
      ),
      floatingActionButton: viewModel.isAdmin ? _buildFabStack() : null,
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowDown): () => viewModel.changeKeyboardSelection(1),
          const SingleActivator(LogicalKeyboardKey.arrowUp): () => viewModel.changeKeyboardSelection(-1),
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
                      child: viewModel.alumniPoster.isEmpty
                          ? const Center(child: Text("Aucun résultat"))
                          : ListView.builder(
                        controller: viewModel.scrollController,
                        itemCount: viewModel.alumniPoster.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => _studentCard(viewModel.alumniPoster[index], isWideScreen),
                      ),
                    ),
                    if (isWideScreen) ...[
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 2,
                        child: viewModel.selectedStudent == null
                            ? _defaultView()
                            : AlumniPreview(alumni: viewModel.selectedStudent!, user: widget.user),
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
          if (viewModel.openFilters) Expanded(child: _buildFilters()),
        ],
      )
          : Column(
        children: [
          Row(children: [Expanded(child: _searchField()), _filterToggleButton()]),
          if (viewModel.openFilters) ...[const SizedBox(height: 15), _buildFilters()],
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: viewModel.searchController,
      onChanged: viewModel.filterResults,
      decoration: InputDecoration(
        hintText: "Recherche...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: viewModel.searchController.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: viewModel.clearSearch)
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
        color: viewModel.openFilters ? AppColors.ensiCyan : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        icon: Icon(viewModel.openFilters ? Icons.filter_list_off : Icons.filter_list,
            color: viewModel.openFilters ? Colors.white : Colors.grey[700]),
        onPressed: viewModel.toggleFilters,
      ),
    );
  }

  Widget _buildFilters() {
    return ZoneFiltres(
      promotionAvailable: viewModel.promotionAvailable,
      selectedPromotion: viewModel.promotionFilterSelected,
      onPromoChanged: (promo, isTicked) {
        isTicked ? viewModel.promotionFilterSelected.add(promo) : viewModel.promotionFilterSelected.remove(promo);
        viewModel.filterResults(viewModel.searchController.text);
      },
      sectorAvailable: viewModel.sectorAvailable,
      sectorFilterSelected: viewModel.sectorFilterSelected,
      onSectorChanged: (filiere, isTicked) {
        isTicked ? viewModel.sectorFilterSelected.add(filiere) : viewModel.sectorFilterSelected.remove(filiere);
        viewModel.filterResults(viewModel.searchController.text);
      },
      internshipCountryAvailable: viewModel.internshipCountryAvailable,
      internshipCountryFilterSelected: viewModel.internshipCountryFilterSelected,
      onInternshipCountryChanged: (pays, isTicked) {
        isTicked ? viewModel.internshipCountryFilterSelected.add(pays) : viewModel.internshipCountryFilterSelected.remove(pays);
        viewModel.filterResults(viewModel.searchController.text);
      },
    );
  }

  Widget _studentCard(Alumnis student, bool isWideScreen) {
    final isSelected = student == viewModel.selectedStudent;
    return Card(
      elevation: isSelected ? 5 : 2,
      color: isSelected ? const Color.fromARGB(255, 210, 210, 210) : Colors.white,
      child: InkWell(
        onTap: () {
          if (isWideScreen) {
            viewModel.selectStudent(student);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlumniDetailPage(alumni: student, user: widget.user, onSave: viewModel.loadInitialData)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: AppColors.ensiCyan, child: Text(student.firstname[0], style: const TextStyle(color: Colors.white))),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${student.wholeName} - ${student.promotion}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (student.job.isNotEmpty) Text("${student.job} @ ${student.company}", style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
              if (viewModel.isAdmin)
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(student)),
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
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminValidationPage())).then((_) => viewModel.loadCounterNotifications()),
          child: Badge(label: Text('${viewModel.numberWaitingRequest}'), isLabelVisible: viewModel.numberWaitingRequest > 0, child: const Icon(Icons.playlist_add_check, color: Colors.white)),
        ),
        const SizedBox(width: 15),
        FloatingActionButton(backgroundColor: AppColors.ensiCyan, onPressed: _openAddModal, child: const Icon(Icons.add, color: Colors.white)),
      ],
    );
  }

  Widget _defaultView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.touch_app, size: 80, color: Colors.grey), Text("Sélectionnez un élève", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))],
      ),
    );
  }

  void _openAddModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvel Alumni"),
        content: SizedBox(width: 500, child: AddAlumniForm(isAdmin: true, onSuccess: () { Navigator.pop(context); viewModel.loadInitialData(); })),
      ),
    );
  }

  Future<void> _confirmDelete(Alumnis student) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: Text("Voulez-vous supprimer ${student.wholeName} ?"),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui"))],
      ),
    ) ?? false;
    if (confirm) viewModel.deleteStudent(student);
  }

  void _displayHistory(BuildContext context) async {
    final logs = await DatabaseService().getHistory();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Historique"),
        content: SizedBox(
          width: 500, height: 400,
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) => ListTile(
              title: Text("${logs[index]['prenom_alumni']} ${logs[index]['nom_alumni']}"),
              subtitle: Text("${logs[index]['action']} le ${logs[index]['date_action']}"),
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer"))],
      ),
    );
  }
}