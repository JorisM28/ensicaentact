import 'package:flutter/material.dart';
import '/ViewModel/widget/key_figure_widget_viewmodel.dart';
import '/l10n/app_localizations.dart';
import '/service_locator.dart';

final Map<String, IconData> availableIcons = {
  'school': Icons.school,
  'public': Icons.public,
  'calendar': Icons.calendar_today,
  'business': Icons.business,
  'euro': Icons.euro_symbol,
  'science': Icons.science,
  'computer': Icons.computer,
  'groups': Icons.groups,
  'rocket': Icons.rocket_launch,
  'event': Icons.event,
  'work': Icons.work,
};

class KeyFiguresWidget extends StatefulWidget {
  final bool isAdmin;
  const KeyFiguresWidget({super.key, required this.isAdmin});

  @override
  State<KeyFiguresWidget> createState() => _KeyFiguresWidgetState();
}

class _KeyFiguresWidgetState extends State<KeyFiguresWidget> {
  final KeyFiguresViewModel _viewModel = sl<KeyFiguresViewModel>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _viewModel.fetchStats();
  }

  Future<void> _handleSave() async {
    if (_isEditing) {
      try {
        bool success = await _viewModel.saveData();
        if (success && mounted) {
          final traductions = AppLocalizations.of(context)!;
          setState(() => _isEditing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(traductions.updateSuccess), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          final traductions = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(traductions.formMsgError(e.toString())), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      setState(() => _isEditing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return Container(
                height: 200,
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator())
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topRight,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _isEditing
                      ? _buildAdminInterface()
                      : _buildPublicInterface(),
                ),

                if (widget.isAdmin)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildSimpleEditButton(),
                  ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildSimpleEditButton() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _viewModel.isSaving ? null : _handleSave,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: _viewModel.isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
            _isEditing ? Icons.check : Icons.edit,
            color: _isEditing ? Colors.green : const Color(0xFFE30613),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildPublicInterface() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 1060;

    return Center(
      key: const ValueKey("Public"),
      child: isMobile
          ? Wrap(
        spacing: 15,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: _viewModel.stats.map((s) {
          double itemWidth = (screenWidth - 60) / 2;
          return SizedBox(
            width: itemWidth,
            child: _buildStatCard(s, compactMode: true),
          );
        }).toList(),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _viewModel.stats.map((s) => _buildStatCard(s, compactMode: false)).toList(),
      ),
    );
  }

  Widget _buildStatCard(KeyFigure stat, {bool compactMode = false}) {
    IconData icon = availableIcons[stat.iconKey] ?? Icons.help;

    double iconSize = compactMode ? 30 : 40;
    double numberSize = compactMode ? 24 : 32;
    double labelSize = compactMode ? 12 : 14;

    return TweenAnimationBuilder<double>(
      key: ValueKey(stat.id),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - val)),
            child: Container(
              decoration: compactMode ? BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ) : null,
              padding: compactMode ? const EdgeInsets.all(10) : EdgeInsets.zero,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(compactMode ? 8 : 12),
                    decoration: BoxDecoration(
                      color: stat.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: stat.color, size: iconSize),
                  ),
                  SizedBox(height: compactMode ? 8 : 10),

                  Text(
                    "${(stat.value * val).toInt()}${stat.suffix}",
                    style: TextStyle(
                      fontSize: numberSize,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: compactMode ? 4 : 5),

                  Text(
                    stat.label,
                    style: TextStyle(
                        fontSize: labelSize,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminInterface() {
    final traductions = AppLocalizations.of(context)!;
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 1060;

    var formSection = Column(
      children: _viewModel.stats.asMap().entries.map((entry) {
        int idx = entry.key;
        KeyFigure stat = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          elevation: 2,
          child: ExpansionTile(
            initiallyExpanded: idx == 0,
            leading: Icon(availableIcons[stat.iconKey], color: stat.color),
            title: Text("${traductions.blockLabel} ${idx + 1} : ${stat.label}", style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: stat.value.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: traductions.numberLabel, border: const OutlineInputBorder()),
                            onChanged: (val) {
                              stat.value = int.tryParse(val) ?? 0;
                              _viewModel.refreshUI();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: stat.suffix,
                            decoration: InputDecoration(labelText: traductions.suffixLabel, border: const OutlineInputBorder()),
                            onChanged: (val) {
                              stat.suffix = val;
                              _viewModel.refreshUI();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: stat.label,
                      decoration: InputDecoration(labelText: traductions.titleLabelAdmin, border: const OutlineInputBorder()),
                      onChanged: (val) {
                        stat.label = val;
                        _viewModel.refreshUI();
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: availableIcons.containsKey(stat.iconKey) ? stat.iconKey : 'school',
                      decoration: InputDecoration(labelText: traductions.iconLabel, border: const OutlineInputBorder()),
                      items: availableIcons.entries.map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Row(children: [Icon(e.value, size: 20), const SizedBox(width: 10), Text(e.key)]),
                      )).toList(),
                      onChanged: (val) {
                        stat.iconKey = val!;
                        _viewModel.refreshUI();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    );

    if (isMobile) {
      return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [formSection, const SizedBox(height: 20)]
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: formSection),
          const VerticalDivider(width: 50),
          Expanded(flex: 5, child: Column(
            children: [
              Chip(label: Text(traductions.livePreview)),
              const SizedBox(height: 35),
              Wrap(
                spacing: 30,
                runSpacing: 30,
                alignment: WrapAlignment.center,
                children: _viewModel.stats.map((s) {
                  return SizedBox(
                    width: 180,
                    child: _buildStatCard(s, compactMode: true),
                  );
                }).toList(),
              ),
            ],
          )),
        ],
      );
    }
  }
}