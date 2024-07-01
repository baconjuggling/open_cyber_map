import 'package:cyber_map/core/config/navigation/navigator_key.dart';
import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/presentation/widgets/components/buttons/app_rounded_button.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:cyber_map/core/presentation/widgets/components/text_fields/app_text_field.dart';
import 'package:cyber_map/core/presentation/widgets/screens/osm_object_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SearchableListWidget<T> extends StatefulWidget {
  const SearchableListWidget({
    required this.title,
    required this.items,
    required this.getLabel,
    required this.getRoute,
    required this.filterItem,
    this.unitName = 'items',
    super.key,
  });
  final String title;
  final List<T> items;
  final String Function(T) getLabel;
  final String Function(T) getRoute;
  final bool Function(T, String) filterItem;
  final String? unitName;

  @override
  _SearchableListWidgetState<T> createState() =>
      _SearchableListWidgetState<T>();
}

class _SearchableListWidgetState<T> extends State<SearchableListWidget<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items.toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterItems() {
    if (_searchText.isEmpty) {
      setState(() {
        _filteredItems = widget.items.toList();
      });
    } else {
      setState(() {
        _filteredItems = widget.items
            .where((item) => widget.filterItem(item, _searchText))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: Expanded(
        child: AppContainer(
          backgroundColor: AppColors.transparentPrimaryAccent,
          child: Column(
            children: [
              Text(
                "${widget.title} ${NumberFormat('#,##0', 'en_GB').format(widget.items.length)}: ${widget.unitName!}",
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: AppTextField(
                  controller: _searchController,
                  hintText: 'Search',
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                      filterItems();
                    });
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppContainer(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppRoundedButton(
                              icon: _filteredItems[index] is Node
                                  ? SvgPicture.asset(
                                      'assets/icons/Osm_element_node.svg',
                                      height: 30,
                                      width: 30,
                                    )
                                  : _filteredItems[index] is Way &&
                                          (_filteredItems[index] as Way).isArea
                                      ? SvgPicture.asset(
                                          'assets/icons/Osm_element_area.svg',
                                          height: 30,
                                          width: 30,
                                        )
                                      : _filteredItems[index] is Way
                                          ? SvgPicture.asset(
                                              'assets/icons/Osm_element_way.svg',
                                              height: 30,
                                              width: 30,
                                            )
                                          : _filteredItems[index] is Relation
                                              ? SvgPicture.asset(
                                                  'assets/icons/Osm_element_relation.svg',
                                                  height: 30,
                                                  width: 30,
                                                )
                                              : _filteredItems[index] is String
                                                  ? SizedBox(
                                                      height: 30,
                                                      width: 30,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                4,
                                                              ),
                                                            ),
                                                          ),
                                                          SvgPicture.asset(
                                                            'assets/icons/Mf_tag.svg',
                                                            height: 30,
                                                            width: 30,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : null,
                              label: widget.getLabel(_filteredItems[index]),
                              onTap: () {
                                navigatorKey.currentState?.pushNamed(
                                  widget.getRoute(_filteredItems[index]),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: AppRoundedButton(
                  label: 'Back',
                  onTap: () {
                    navigatorKey.currentState?.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
