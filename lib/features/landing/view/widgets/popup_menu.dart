// // ignore: must_be_immutable
// import 'package:flutter/material.dart';

// class MenuAnchorIcon extends StatefulWidget {
//   dynamic onSelected;
//   MenuAnchorIcon({
//     super.key,
//     this.onSelected,
//   });
//   @override
//   State<MenuAnchorIcon> createState() => MenuAnchorState();
// }

// class MenuAnchorState extends State<MenuAnchorIcon> {
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       splashRadius: 24,

//       color: Colors.white,
//       surfaceTintColor: Colors.white,
//       offset: const Offset(0, 40),
//       tooltip: "Chi tiết",
//       itemBuilder: (_) => <PopupMenuItem<String>>[
//         PopupMenuItem(
//           value: 'download',
//           height: 30,
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: SvgService.getSvgPictureFromAsset(assetSvgs.download),
//               ),
//               Text(
//                 'Tải xuống',
//                 style: menuTextStyle,
//               ),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//             value: 'rename',
//             height: 30,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(5),
//                   child: SvgService.getSvgPictureFromAsset(assetSvgs.edit,
//                       width: 24, height: 24),
//                 ),
//                 Text('Đổi tên', style: menuTextStyle),
//               ],
//             )),
//         // const PopupMenuDivider(),
//         PopupMenuItem(
//             value: 'share',
//             height: 30,
//             child: SizedBox(
//               width: 300,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5),
//                         child: SvgService.getSvgPictureFromAsset(
//                             assetSvgs.groupAdd),
//                       ),
//                       Text('Chia sẻ', style: menuTextStyle),
//                     ],
//                   ),
//                   NestedMenu(
//                     options: const [
//                       'option 1',
//                       'option 2',
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//         PopupMenuItem(
//             value: 'sort',
//             height: 30,
//             child: SizedBox(
//               width: 300,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5),
//                         child: SvgService.getSvgPictureFromAsset(
//                             assetSvgs.folderSupervised,
//                             width: 24,
//                             height: 24),
//                       ),
//                       Text('Sắp xếp', style: menuTextStyle),
//                     ],
//                   ),
//                   NestedMenu(
//                     options: const [
//                       'option 1',
//                       'option 2',
//                       'option 3',
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//         PopupMenuItem(
//             value: 'info',
//             height: 30,
//             child: SizedBox(
//               width: 300,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(5),
//                         child: SvgService.getSvgPictureFromAsset(
//                           assetSvgs.info,
//                           width: 24,
//                           height: 24,
//                         ),
//                       ),
//                       Text('Thông tin về tệp', style: menuTextStyle),
//                     ],
//                   ),
//                   NestedMenu(
//                     options: const [
//                       'option 1',
//                       'option 2',
//                       'option 3',
//                       'option 4',
//                     ],
//                   ),
//                 ],
//               ),
//             )),
//         // const PopupMenuDivider(),
//         PopupMenuItem(
//             value: 'delete',
//             height: 30,
//             child: Row(
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: SvgService.getSvgPictureFromAsset(
//                       assetSvgs.delete,
//                     )),
//                 Text('Xóa tài liệu', style: menuTextStyle),
//               ],
//             ))
//       ],
//       // shadowColor: Colors.white,
//       onSelected: widget.onSelected,
//     );
//   }
// }
