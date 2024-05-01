// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../../../../../../shared/components.dart';
// import '../../../../../../../../utilities/app_ui.dart';
// import '../../../../../../../../utilities/app_util.dart';
// import 'package:ahshiaka/shared/CheckNetwork.dart';

// class SelectAddressFromMap extends StatefulWidget {
//   final double? lat, lng;
//   const SelectAddressFromMap({Key? key, this.lat, this.lng}) : super(key: key);

//   @override
//   _SelectAddressFromMapState createState() => _SelectAddressFromMapState();
// }

// class _SelectAddressFromMapState extends State<SelectAddressFromMap> {
//   GoogleMapController? googleMapController;

//   Position? posision;
//   LatLng? _currentLocation;
//   late List address = ["", ""];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     myLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CheckNetwork(
//       child: Scaffold(
//           appBar:
//               widget.lat == null ? null : customAppBar(title: "location".tr()),
//           body: _currentLocation != null
//               ? Stack(
//                   children: [
//                     GoogleMap(
//                       onMapCreated: (map) async {
//                         googleMapController = map;
//                         posision = await AppUtil.determinePosition();
//                         googleMapController!.animateCamera(
//                             CameraUpdate.newCameraPosition(CameraPosition(
//                                 target: LatLng(_currentLocation!.latitude,
//                                     _currentLocation!.longitude),
//                                 zoom: 1)));
//                         // _currentLocation = LatLng(posision!.latitude, posision!.longitude);
//                         // address = await AppUtil.getAddress(LatLng(_currentLocation!.latitude, _currentLocation!.longitude));
//                       },
//                       onCameraMove: (CameraPosition position) async {
//                         _currentLocation = position.target;
//                         // address = await AppUtil.getAddress(LatLng(_currentLocation!.latitude, _currentLocation!.longitude));
//                         // setState(() {
//                         //
//                         // });
//                       },
//                       initialCameraPosition: CameraPosition(
//                           target: LatLng(
//                             _currentLocation!.latitude,
//                             _currentLocation!.longitude,
//                           ),
//                           zoom: 1),
//                       // myLocationButtonEnabled: true,
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: false,
//                       markers: widget.lng != null
//                           ? {
//                               Marker(
//                                   markerId: MarkerId(widget.lat.toString()),
//                                   position: LatLng(widget.lat!, widget.lng!))
//                             }
//                           : {},
//                     ),
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Column(
//                         children: [
//                           CustomAppBar(title: "addresses".tr()),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: InkWell(
//                                   onTap: () {
//                                     print('vjkndfjkv');
//                                     googleMapController!.animateCamera(
//                                         CameraUpdate.newCameraPosition(
//                                             CameraPosition(
//                                                 target: LatLng(
//                                                     posision!.latitude,
//                                                     posision!.longitude),
//                                                 zoom: 8)));
//                                   },
//                                   child: CircleAvatar(
//                                     radius: 25,
//                                     backgroundColor: AppUI.whiteColor,
//                                     child: SvgPicture.asset(
//                                       "${AppUI.iconPath}location.svg",
//                                       color: AppUI.orangeColor,
//                                       height: 30,
//                                       width: 30,
//                                     ),
//                                   ),
//                                 ),
//                                 // child: CustomCard(
//                                 //   child: Row(
//                                 //     children: [
//                                 //       SvgPicture.asset("${AppUI.iconPath}location.svg",color: AppUI.orangeColor,height: 30,width: 30,),
//                                 //       const SizedBox(width: 10,),
//                                 //       Column(
//                                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                                 //         children: [
//                                 //           SizedBox(
//                                 //             width: AppUtil.responsiveWidth(context)*0.7,
//                                 //               child: CustomText(text: address[1],fontWeight: FontWeight.w500,)),
//                                 //           // CustomText(text: "Reiadh",fontSize: 12,),
//                                 //         ],
//                                 //       )
//                                 //     ],
//                                 //   ),
//                                 // ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     if (widget.lat == null)
//                       SizedBox.expand(
//                         child: Center(
//                             child: Icon(
//                           Icons.add_location,
//                           color: AppUI.orangeColor,
//                           size: 50,
//                         )),
//                       ),
//                     if (widget.lat == null)
//                       Positioned(
//                         bottom: 50,
//                         right: 20,
//                         left: 20,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 50),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CustomButton(
//                                 text: "select".tr(),
//                                 onPressed: () async {
//                                   address = await AppUtil.getAddress(LatLng(
//                                       _currentLocation!.latitude,
//                                       _currentLocation!.longitude));
//                                   if (address[2].toString().toLowerCase() !=
//                                       "sa") {
//                                     AppUtil.newErrorToastTOP(
//                                         context, "youMustBeInSaudiArabia".tr());
//                                     return;
//                                   }
//                                   if (!mounted) return;
//                                   Navigator.pop(context, address);
//                                 },
//                                 width: AppUtil.responsiveWidth(context) * 0.93,
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                   ],
//                 )
//               : const Center(child: CircularProgressIndicator())),
//     );
//   }

//   myLocation() async {
//     if (widget.lat == null) {
//       posision = await AppUtil.determinePosition();
//       _currentLocation = LatLng(posision!.latitude, posision!.longitude);
//     } else {
//       _currentLocation = LatLng(widget.lat!, widget.lng!);
//     }
//     setState(() {});
//   }
// }
