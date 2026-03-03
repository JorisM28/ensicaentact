import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/View/theme/colors.dart';
import '/Model/alumnis.dart';
import '/ViewModel/alumni/alumni_viewmodel.dart';
import '/Model/user_model.dart';
import '/View/widget/custom_app_bar.dart';
import '/service_locator.dart';
import '/Model/data/services/auth_service.dart';

class AlumniDetailPage extends StatefulWidget {
  final Alumnis alumni;
<<<<<<< HEAD
=======
  final User user;
>>>>>>> 3ed3c121283449efcd82b1039d7f9736fe0ed6fd
  final VoidCallback? onSave;

  const AlumniDetailPage({super.key, required this.alumni, this.onSave});

  @override
  State<AlumniDetailPage> createState() => _AlumniDetailPageState();
}

class _AlumniDetailPageState extends State<AlumniDetailPage> {
  late AlumniViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AlumniViewModel(widget.alumni);
    viewModel.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _selectionnerDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final currentUser = sl<AuthService>().currentUser;
    final bool isAdmin = currentUser!['role'] == 'admin';
=======
    final bool isAdmin = widget.user.isAdmin;
>>>>>>> 3ed3c121283449efcd82b1039d7f9736fe0ed6fd
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isBig = screenWidth > 800;

    return Scaffold(
        appBar: CustomAppBar(),
        floatingActionButton: isAdmin ? FloatingActionButton.extended(
        onPressed: () async {
          if (viewModel.isEdited) {
            try {
              await viewModel.save(context, widget.onSave);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profil mis à jour avec succès !"), 
                    backgroundColor: Colors.green
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Erreur lors de la sauvegarde : $e"), 
                    backgroundColor: Colors.red
                  ),
                );
              }
            }
          } else {
            setState(() {
              viewModel.isEdited = true;
            });
          }
        },
        backgroundColor: viewModel.isEdited ? Colors.green : AppColors.ensiCyan,
        icon: Icon(viewModel.isEdited ? Icons.save : Icons.edit, color: Colors.white),
        label: Text(
          viewModel.isEdited ? "Enregistrer" : "Modifier",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 10),
                if (viewModel.isEdited) _buildEditFields() else _buildDisplayHeader(),
                const SizedBox(height: 20),
                _buildMainInfoSections(isBig),
                const SizedBox(height: 20),
                _buildContactCard(screenWidth),
                const SizedBox(height: 30),
                _buildInternshipSection(screenWidth, isBig),
              ],
            ),
          ),

          Positioned(
            top: 15,
            left: 15,
            child: FloatingActionButton.small(
              elevation: 4,
              backgroundColor: AppColors.ensiCyan,
              foregroundColor: Colors.white,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
          if(isAdmin)
            Positioned(
              top: 15,
              right: 15,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (viewModel.isEdited) {
                    try {
                      await viewModel.save(context, widget.onSave);
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profil mis à jour avec succès !"), 
                            backgroundColor: Colors.green
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erreur lors de la sauvegarde : $e"), 
                            backgroundColor: Colors.red
                          ),
                        );
                      }
                    }
                  } else {
                    setState(() {
                      viewModel.isEdited = true;
                    });
                  }
                },
                backgroundColor: viewModel.isEdited ? Colors.green : AppColors.ensiCyan,
                icon: Icon(viewModel.isEdited ? Icons.save : Icons.edit, color: Colors.white),
                label: Text(
                  viewModel.isEdited ? "Enregistrer" : "Modifier",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.ensiCyan,
      child: Text(
        viewModel.currentAlumni.firstname.isNotEmpty ? viewModel.currentAlumni.firstname[0] : "?",
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }

  Widget _buildDisplayHeader() {
    return Column(
      children: [
        Text("${viewModel.currentAlumni.firstname} ${viewModel.currentAlumni.lastName}",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        Text("Promo ${viewModel.currentAlumni.promotion}",
            style: const TextStyle(fontSize: 20, color: Colors.grey)),
        if (viewModel.currentAlumni.dateOfBirth.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(viewModel.calculateAge(viewModel.currentAlumni.dateOfBirth),
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          ),
        const Divider(height: 40),
      ],
    );
  }

  Widget _buildEditFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: TextField(controller: viewModel.firstNameController, decoration: const InputDecoration(labelText: "Prénom", border: OutlineInputBorder()))),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: viewModel.lastNameController, decoration: const InputDecoration(labelText: "Nom", border: OutlineInputBorder()))),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: viewModel.promotionController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: "Promo (Année)", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: viewModel.dateOfBirthController,
          decoration: const InputDecoration(labelText: "Date de Naissance", border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
          readOnly: true,
          onTap: () => _selectionnerDate(context, viewModel.dateOfBirthController),
        ),
        const Divider(height: 40),
        Card(
          color: Colors.grey[100],
          elevation: 0,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(8.0), child: Text("Statut Administrateur", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
              SwitchListTile(
                  title: const Text("Autorisation des données"),
                  subtitle: Text(viewModel.permissionSwitch ? "Visible" : "Caché"),
                  activeColor: Colors.green,
                  value: viewModel.permissionSwitch,
                  onChanged: (val) => setState(() => viewModel.permissionSwitch = val)),
              const Divider(height: 1),
              SwitchListTile(
                  title: const Text("Décédé"),
                  subtitle: const Text("Marquer comme décédé"),
                  activeColor: Colors.red,
                  value: viewModel.deceasedSwitch,
                  onChanged: (val) => setState(() => viewModel.deceasedSwitch = val)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfoSections(bool isBig) {
    List<Widget> etuItems = [
      if (viewModel.currentAlumni.sector.isNotEmpty || viewModel.isEdited) ...[
        _buildEditableTile(Icons.school, Colors.orange, "Filière", viewModel.sectorController, viewModel.currentAlumni.sector),
        const Divider(height: 1),
      ],
      _buildEditableTile(Icons.book, Colors.redAccent, "Majeure", viewModel.specialisationController, viewModel.currentAlumni.specialisation),
      const Divider(height: 1),
      _buildEditableTile(Icons.bookmark, Colors.pinkAccent, "Option", viewModel.optionController, viewModel.currentAlumni.option),
      const Divider(height: 1),
      _buildEditableTile(Icons.workspace_premium, Colors.purple, "Double Diplôme", viewModel.doubleDiplomaController, viewModel.currentAlumni.doubleDiploma),
    ];

    List<Widget> proItems = [
      if (viewModel.isEdited) ...[
        _buildEditableTile(Icons.work, Colors.blue, "Poste", viewModel.positionController, viewModel.currentAlumni.job),
        const SizedBox(height: 10),
        _buildEditableTile(Icons.description, Colors.grey, "Description du poste", viewModel.positionDescController, viewModel.currentAlumni.jobDescription),
      ] else if (viewModel.currentAlumni.job.isNotEmpty) ...[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: const Icon(Icons.work, color: Colors.blue, size: 24),
          title: const Text("Poste", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          subtitle: Text(viewModel.currentAlumni.job, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          trailing: viewModel.currentAlumni.jobDescription.isNotEmpty
              ? IconButton(
            icon: Icon(viewModel.seeDescription ? Icons.remove_circle_outline : Icons.add_circle_outline, color: AppColors.ensiCyan),
            onPressed: () => setState(() => viewModel.seeDescription = !viewModel.seeDescription),
          )
              : null,
        ),
        if (viewModel.seeDescription && viewModel.currentAlumni.jobDescription.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[50], border: Border(left: BorderSide(color: AppColors.ensiCyan, width: 3))),
              child: Text(viewModel.currentAlumni.jobDescription, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87)),
            ),
          ),
      ],
      const Divider(height: 1),
      _buildEditableTile(Icons.location_on, Colors.red, "Ville", viewModel.cityController, viewModel.currentAlumni.city),
      const Divider(height: 1),
      _buildEditableTile(Icons.business, Colors.indigo, "Entreprise", viewModel.companyController, viewModel.currentAlumni.company),
      if (!viewModel.isEdited && viewModel.startPosDateController.text.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.timer, color: Colors.teal),
          title: const Text("Ancienneté"),
          subtitle: Text("${viewModel.startPosDateController.text} (${viewModel.calculateSeniority(viewModel.startPosDateController.text)})"),
        )
      else if (viewModel.isEdited)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextFormField(
            controller: viewModel.startPosDateController,
            decoration: const InputDecoration(labelText: "Date de début (Poste)", border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
            readOnly: true,
            onTap: () => _selectionnerDate(context, viewModel.startPosDateController),
          ),
        ),
    ];

    if (isBig) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoCard(title: "Infos Pro", items: proItems)),
          const SizedBox(width: 20),
          Expanded(child: _buildInfoCard(title: "Etudes", items: etuItems)),
        ],
      );
    }
    return Column(
      children: [
        _buildInfoCard(title: "Infos Pro", items: proItems),
        const SizedBox(height: 20),
        _buildInfoCard(title: "Etudes", items: etuItems),
      ],
    );
  }

  Widget _buildContactCard(double screenWidth) {
    if (!viewModel.isEdited && (viewModel.currentAlumni.permission == 0 || viewModel.currentAlumni.deceased == 1)) {
      return const Card(elevation: 1, child: Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text("Coordonnées masquées", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)))));
    }

    bool modeLigne = screenWidth > 600 && viewModel.currentAlumni.email.isNotEmpty && viewModel.currentAlumni.phone.isNotEmpty;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(10.0), child: Text("Contact", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          if (modeLigne)
            Row(
              children: [
                Expanded(child: _buildEditableTile(Icons.email, Colors.green, "Email", viewModel.emailController, viewModel.currentAlumni.email)),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(child: _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", viewModel.phoneController, viewModel.currentAlumni.phone)),
              ],
            )
          else
            Column(
              children: [
                _buildEditableTile(Icons.email, Colors.green, "Email", viewModel.emailController, viewModel.currentAlumni.email),
                const Divider(indent: 20, endIndent: 20, height: 1),
                _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", viewModel.phoneController, viewModel.currentAlumni.phone),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInternshipSection(double screenWidth, bool isBig) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Stages", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            if (viewModel.isEdited)
              ElevatedButton.icon(
                onPressed: viewModel.addInternship,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Ajouter"),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.ensiCyan, foregroundColor: Colors.white),
              )
          ],
        ),
        const SizedBox(height: 10),
        if (viewModel.isEdited)
          ...viewModel.internshipEditors.asMap().entries.map((entry) {
            int index = entry.key;
            var editor = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Stage #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => viewModel.deleteInternship(index)),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: ['1A', '2A', '3A'].contains(editor.year.text) ? editor.year.text : null,
                          decoration: const InputDecoration(labelText: "Année", border: OutlineInputBorder()),
                          items: const [DropdownMenuItem(value: '1A', child: Text("1A")), DropdownMenuItem(value: '2A', child: Text("2A")), DropdownMenuItem(value: '3A', child: Text("3A"))],
                          onChanged: (v) => v != null ? setState(() => editor.year.text = v) : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: editor.type,
                          decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()),
                          items: const [DropdownMenuItem(value: 'E', child: Text("Entreprise")), DropdownMenuItem(value: 'U', child: Text("Université"))],
                          onChanged: (v) => setState(() => editor.type = v!),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: editor.start,
                            decoration: const InputDecoration(
                              labelText: "Date de début", 
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today, size: 20),
                            ),
                            readOnly: true,
                            onTap: () => _selectionnerDate(context, editor.start),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: editor.end,
                            decoration: const InputDecoration(
                              labelText: "Date de fin", 
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.event, size: 20),
                            ),
                            readOnly: true,
                            onTap: () => _selectionnerDate(context, editor.end),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: editor.entilted, decoration: const InputDecoration(labelText: "Intitulé", border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    TextField(controller: editor.entreprise, decoration: const InputDecoration(labelText: "Entreprise", border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: TextField(controller: editor.city, decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: editor.country, decoration: const InputDecoration(labelText: "Pays", border: OutlineInputBorder()))),
                    ]),
                    const SizedBox(height: 10),
                    TextField(controller: editor.description, maxLines: 3, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
                  ],
                ),
              ),
            );
          }).toList()
        else
          viewModel.internshipDisplay.isEmpty
              ? const Card(
                  child: ListTile(
                      title: Text("Aucun stage renseigné",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey))))
              : isBig
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: viewModel.internshipDisplay.map((s) {
                        bool isLast = s == viewModel.internshipDisplay.last;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 15.0),
                            child: _buildInternshipCard(s),
                          ),
                        );
                      }).toList(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: viewModel.internshipDisplay
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: _buildInternshipCard(s),
                              ))
                          .toList(),
                    ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          ...items,
        ],
      ),
    );
  }

  Widget _buildEditableTile(IconData icon, Color color, String title, TextEditingController controller, String currentValue) {
    if (currentValue.isEmpty && !viewModel.isEdited) return const SizedBox.shrink();
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: color, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
      subtitle: viewModel.isEdited
          ? TextField(controller: controller, decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), contentPadding: EdgeInsets.all(8)))
          : Text(currentValue, style: const TextStyle(fontSize: 16, color: Colors.black87)),
    );
  }

  Widget _buildInternshipCard(dynamic stage) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(stage.type == "E" ? Icons.apartment : Icons.school,
                    color: AppColors.ensiCyan, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${stage.year} - ${stage.entitled}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInternshipField(
                stage.type == "U" ? "Université" : "Entreprise",
                stage.type == "E" ? Icons.apartment : Icons.school,
                Colors.green,
                stage.company),
            _buildInternshipField("Lieu", Icons.location_on, Colors.red,
                "${stage.city}, ${stage.country}",
                isItalic: true),
            if (stage.startDate.isNotEmpty || stage.endDate.isNotEmpty)
              _buildInternshipField("Période", Icons.calendar_today, Colors.blue,
                  "${stage.startDate} au ${stage.endDate}"),
            _buildInternshipField("Description", Icons.insert_drive_file,
                Colors.grey, stage.description),
          ],
        ),
      ),
    );
  }

  Widget _buildInternshipField(String label, IconData icon, Color color, String value, {bool isItalic = false}) {
    if (value.isEmpty || value == ", ") return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: color, size: 14), const SizedBox(width: 4), Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ensiCyan))]),
          Padding(padding: const EdgeInsets.only(left: 18.0), child: Text(value, style: TextStyle(fontSize: 15, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal))),
        ],
      ),
    );
  }
}