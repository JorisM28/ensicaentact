import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/View/widget/base_layout.dart';
import '/Model/alumnis.dart';
import '/ViewModel/alumni/alumni_viewmodel.dart';
import '/l10n/app_localizations.dart'; 
import '/View/theme/colors.dart';
import '/service_locator.dart';
import '/Model/data/services/auth_service.dart';

class AlumniDetailPage extends StatefulWidget {
  final Alumnis alumni;
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      locale: Locale(Localizations.localeOf(context).languageCode),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!; 
    final currentUser = sl<AuthService>().currentUser;
    final bool isAdmin = currentUser?.role == 'admin';
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isBig = screenWidth > 800;

    return BaseLayout(
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
                          SnackBar(
                            content: Text(traductions.profileUpdatedSuccess), 
                            backgroundColor: Colors.green
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(traductions.formMsgError(e.toString())), 
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
                  viewModel.isEdited ? traductions.saveBtn : traductions.editBtn,
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
      final traductions = AppLocalizations.of(context)!; 

      return Column(
        children: [
          Text("${viewModel.currentAlumni.firstname} ${viewModel.currentAlumni.lastName}",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          
          Text("${traductions.detailLabelPromo} ${viewModel.currentAlumni.promotion}",
              style: const TextStyle(fontSize: 20, color: Colors.grey)),
          
          if (viewModel.currentAlumni.dateOfBirth.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                  traductions.detailAge(viewModel.calculateAge(viewModel.currentAlumni.dateOfBirth)),
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)
              ),
            ),
            
          const Divider(height: 40),
        ],
      );
    }

  Widget _buildEditFields() {
    final traductions = AppLocalizations.of(context)!; 
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: TextField(controller: viewModel.firstNameController, decoration: InputDecoration(labelText: traductions.detailLabelFirstName, border: OutlineInputBorder()))),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: viewModel.lastNameController, decoration: InputDecoration(labelText: traductions.detailLabelLastName, border: OutlineInputBorder()))),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: viewModel.promotionController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: traductions.detailLabelPromo, border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: viewModel.dateOfBirthController,
          decoration: InputDecoration(labelText: traductions.detailLabelBirthDate, border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
          readOnly: true,
          onTap: () => _selectDate(context, viewModel.dateOfBirthController),
        ),
        const Divider(height: 40),
        Card(
          color: Colors.grey[100],
          elevation: 0,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(8.0), child: Text(traductions.detailAdminStatus, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
              SwitchListTile(
                  title: Text(traductions.detailPermissionData),
                  subtitle: Text(viewModel.permissionSwitch ? traductions.detailVisible : traductions.detailHidden),
                  activeColor: Colors.green,
                  value: viewModel.permissionSwitch,
                  onChanged: (val) => setState(() => viewModel.permissionSwitch = val)),
              const Divider(height: 1),
              SwitchListTile(
                  title: Text(traductions.detailDeceased),
                  subtitle:  Text(traductions.detailDeceasedSubtitle),
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
    final traductions = AppLocalizations.of(context)!; 
    List<Widget> etuItems = [
      if (viewModel.currentAlumni.sector.isNotEmpty || viewModel.isEdited) ...[
        _buildEditableTile(Icons.school, Colors.orange, traductions.detailLabelSector, viewModel.sectorController, viewModel.currentAlumni.sector),
        const Divider(height: 1),
      ],
      _buildEditableTile(Icons.book, Colors.redAccent, traductions.detailLabelSpecialisation, viewModel.specialisationController, viewModel.currentAlumni.specialisation),
      const Divider(height: 1),
      _buildEditableTile(Icons.bookmark, Colors.pinkAccent, traductions.detailLabelOption, viewModel.optionController, viewModel.currentAlumni.option),
      const Divider(height: 1),
      _buildEditableTile(Icons.workspace_premium, Colors.purple, traductions.detailLabelDoubleDiploma, viewModel.doubleDiplomaController, viewModel.currentAlumni.doubleDiploma),
    ];

    List<Widget> proItems = [
      if (viewModel.isEdited) ...[
        _buildEditableTile(Icons.work, Colors.blue, traductions.detailLabelJob, viewModel.positionController, viewModel.currentAlumni.job),
        const SizedBox(height: 10),
        _buildEditableTile(Icons.description, Colors.grey, traductions.detailLabelJobDesc, viewModel.positionDescController, viewModel.currentAlumni.jobDescription),
      ] else if (viewModel.currentAlumni.job.isNotEmpty) ...[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: const Icon(Icons.work, color: Colors.blue, size: 24),
          title: Text(traductions.detailLabelJob, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
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
      _buildEditableTile(Icons.location_on, Colors.red, traductions.detailLabelCity, viewModel.cityController, viewModel.currentAlumni.city),
      const Divider(height: 1),
      _buildEditableTile(Icons.business, Colors.indigo, traductions.detailLabelCompany, viewModel.companyController, viewModel.currentAlumni.company),
      const Divider(height: 1),
      _buildEditableTile(Icons.location_city, const Color.fromARGB(255, 140, 92, 252), traductions.detailLabelPostalCode, viewModel.postalCodeController, viewModel.currentAlumni.postalCode),

      if (!viewModel.isEdited && viewModel.startPosDateController.text.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.timer, color: Colors.teal),
          title: Text(traductions.detailLabelSeniority),
          subtitle: Text("${viewModel.startPosDateController.text} (${viewModel.calculateSeniority(viewModel.startPosDateController.text)})"),
        )
      else if (viewModel.isEdited)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextFormField(
            controller: viewModel.startPosDateController,
            decoration: InputDecoration(labelText: traductions.detailLabelStartDate, border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
            readOnly: true,
            onTap: () => _selectDate(context, viewModel.startPosDateController),
          ),
        ),
    ];

    if (isBig) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoCard(title: traductions.detailInfoPro, items: proItems)),
          const SizedBox(width: 20),
          Expanded(child: _buildInfoCard(title: traductions.detailInfoStudies, items: etuItems)),
        ],
      );
    }
    return Column(
      children: [
        _buildInfoCard(title: traductions.detailInfoPro, items: proItems),
        const SizedBox(height: 20),
        _buildInfoCard(title:  traductions.detailInfoStudies, items: etuItems),
      ],
    );
  }

  Widget _buildContactCard(double screenWidth) {
    final traductions = AppLocalizations.of(context)!; 
    if (!viewModel.isEdited && (viewModel.currentAlumni.permission == 0 || viewModel.currentAlumni.deceased == 1)) {
      return Card(elevation: 1, child: Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text(traductions.detailContactHidden, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)))));
    }

    bool lineMode = screenWidth > 600 && viewModel.currentAlumni.email.isNotEmpty && viewModel.currentAlumni.phone.isNotEmpty;

    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(10.0), child: Text(traductions.contactLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          if (lineMode)
            Row(
              children: [
                Expanded(child: _buildEditableTile(Icons.email, Colors.green, traductions.profileEmail, viewModel.emailController, viewModel.currentAlumni.email)),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(child: _buildEditableTile(Icons.phone, Colors.amber, traductions.profilePhone, viewModel.phoneController, viewModel.currentAlumni.phone)),
              ],
            )
          else
            Column(
              children: [
                _buildEditableTile(Icons.email, Colors.green, traductions.profileEmail, viewModel.emailController, viewModel.currentAlumni.email),
                const Divider(indent: 20, endIndent: 20, height: 1),
                _buildEditableTile(Icons.phone, Colors.amber, traductions.profilePhone, viewModel.phoneController, viewModel.currentAlumni.phone),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInternshipSection(double screenWidth, bool isBig) {
    final traductions = AppLocalizations.of(context)!; 
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(traductions.detailInternshipTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            if (viewModel.isEdited)
              ElevatedButton.icon(
                onPressed: viewModel.addInternship,
                icon: const Icon(Icons.add, size: 18),
                label: Text(traductions.detailInternshipAdd),
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
                        Text("${traductions.detailInternshipTitle} #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => viewModel.deleteInternship(index)),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: ['1A', '2A', '3A'].contains(editor.year.text) ? editor.year.text : null,
                          decoration: InputDecoration(labelText: traductions.detailLabelPromo, border: OutlineInputBorder()),
                          items: const [DropdownMenuItem(value: '1A', child: Text("1A")), DropdownMenuItem(value: '2A', child: Text("2A")), DropdownMenuItem(value: '3A', child: Text("3A"))],
                          onChanged: (v) => v != null ? setState(() => editor.year.text = v) : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: editor.type,
                          decoration: InputDecoration(labelText: traductions.typeLabel, border: OutlineInputBorder()),
                          items: [DropdownMenuItem(value: 'E', child: Text(traductions.detailInternshipCompany)), DropdownMenuItem(value: 'U', child: Text(traductions.detailInternshipUniversity))],
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
                            decoration: InputDecoration(
                              labelText: traductions.detailLabelStartDate, 
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today, size: 20),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context, editor.start),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: editor.end,
                            decoration: InputDecoration(
                              labelText: traductions.detailLabelEndDate, 
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.event, size: 20),
                            ),
                            readOnly: true,
                            onTap: () => _selectDate(context, editor.end),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(controller: editor.entilted, decoration: InputDecoration(labelText: traductions.jobTitleLabel, border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    TextField(controller: editor.entreprise, decoration: InputDecoration(labelText: traductions.detailLabelCompany, border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(child: TextField(controller: editor.city, decoration: InputDecoration(labelText: traductions.detailLabelCity, border: OutlineInputBorder()))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: editor.country, decoration: InputDecoration(labelText: traductions.detailLabelCountry, border: OutlineInputBorder()))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: editor.postalCode, decoration: InputDecoration(labelText: traductions.detailLabelPostalCode, border: OutlineInputBorder()))),
                    ]),
                    const SizedBox(height: 10),
                    TextField(controller: editor.description, maxLines: 3, decoration: InputDecoration(labelText: traductions.detailLabelDescription, border: OutlineInputBorder())),
                  ],
                ),
              ),
            );
          }).toList()
        else
          viewModel.internshipDisplay.isEmpty
              ? Card(
                  child: ListTile(
                      title: Text(traductions.detailInternshipNone,
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

  Widget _buildInternshipCard(dynamic internship) {
    final traductions = AppLocalizations.of(context)!; 
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
                Icon(internship.type == "E" ? Icons.apartment : Icons.school,
                    color: AppColors.ensiCyan, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${internship.year} - ${internship.entitled}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInternshipField(
                internship.type == "U" ? traductions.detailInternshipUniversity : traductions.detailInternshipCompany,
                internship.type == "E" ? Icons.apartment : Icons.school,
                Colors.green,
                internship.company),
            _buildInternshipField(traductions.detailInternshipLocation, Icons.location_on, Colors.red,
                "${internship.city}, ${internship.country}, ${internship.country}",
                isItalic: true),
            if (internship.startDate.isNotEmpty || internship.endDate.isNotEmpty)
              _buildInternshipField(traductions.detailInternshipPeriod, Icons.calendar_today, Colors.blue,
                  "${internship.startDate} au ${internship.endDate}"),
            _buildInternshipField(traductions.detailInternshipDescription, Icons.insert_drive_file,
                Colors.grey, internship.description),
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