import 'package:ai_assisted_reader/widgets/reading_page/more_settings/page_turning/diagram.dart';

List<PageTurningType> type1 = [
  PageTurningType.prev,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.menu,
  PageTurningType.next
];
List<int> icon1 = [5, 3, 4];

List<PageTurningType> type2 = [
  PageTurningType.prev,
  PageTurningType.prev,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.next,
  PageTurningType.next
];
List<int> icon2 = [5, 3, 4];

List<PageTurningType> type3 = [
  PageTurningType.prev,
  PageTurningType.prev,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.next
];
List<int> icon3 = [5, 3, 4];

List<PageTurningType> type4 = [
  PageTurningType.menu,
  PageTurningType.menu,
  PageTurningType.menu,
  PageTurningType.prev,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.next,
  PageTurningType.next
];
// next, prev, menu
List<int> icon4 = [5, 3, 1];

List<PageTurningType> type5 = [
  PageTurningType.next,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.prev,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.next
];
// next, prev, menu from 0
List<int> icon5 = [7, 4, 1];

// type6: left/right → next, center → menu, swipe left → prev
List<PageTurningType> type6 = [
  PageTurningType.next,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.menu,
  PageTurningType.next,
  PageTurningType.next,
  PageTurningType.menu,
  PageTurningType.next
];
// next(0), prev(-1=none), menu(1)
List<int> icon6 = [0, -1, 1];

List<List<PageTurningType>> pageTurningTypes = [
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
];
List<List<int>> pageTurningIcons = [icon1, icon2, icon3, icon4, icon5, icon6];
