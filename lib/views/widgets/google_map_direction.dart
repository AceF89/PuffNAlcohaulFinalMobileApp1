import 'dart:async';
import 'package:alcoholdeliver/apis/google_map_api/google_map_api.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/model/google/google_direction.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapDirection extends StatefulWidget {
  final String originName;
  final bool hideOriginMarker;
  final LatLng? originCoordinates;
  final LatLng? destinationCoordinates;
  final String destinationName;
  final Set<Marker>? externalMarkers;

  const GoogleMapDirection({
    super.key,
    this.originCoordinates,
    this.hideOriginMarker = false,
    this.originName = '',
    this.destinationCoordinates,
    this.destinationName = '',
    this.externalMarkers,
  });

  @override
  State<GoogleMapDirection> createState() => _GoogleMapDirectionState();
}

class _GoogleMapDirectionState extends State<GoogleMapDirection> {
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final GoogleMapApi _api = GoogleMapApi.instance;

  GoogleMapController? _googleMapController;

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(covariant GoogleMapDirection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.externalMarkers != widget.externalMarkers ||
        oldWidget.originCoordinates != widget.originCoordinates ||
        oldWidget.destinationCoordinates != widget.destinationCoordinates) {
      _buildMarkers();
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  void _buildMarkers() {
    setState(() {
      _markers.clear();

      if (widget.originCoordinates != null && widget.destinationCoordinates != null) {
        _markers.addAll([
          if (!widget.hideOriginMarker)
            Marker(
              markerId: MarkerId(widget.originName),
              position: widget.originCoordinates!,
              infoWindow: InfoWindow(title: widget.originName),
            ),
          Marker(
            markerId: MarkerId(widget.destinationName),
            position: widget.destinationCoordinates!,
            infoWindow: InfoWindow(title: widget.destinationName),
          ),
        ]);
      }

      if (widget.externalMarkers != null) {
        _markers.addAll(widget.externalMarkers!);
        _fetchAndSetPolylines();
      }
    });
  }

  Future<void> _fetchAndSetPolylines() async {
    final result = await _api.getDirection(
      origin: widget.originCoordinates,
      destination: widget.destinationCoordinates,
    );

    result.when(
      _setPolylineWithoutRefresh,
      (error) {},
    );
  }

  Future<void> _setPolylineWithoutRefresh(GoogleDirection direction) async {
    final String polylineIdVal = 'polyline_${_polylines.length + 1}';

    final polyline = Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: AppColors.primaryColor,
      points: direction.decodedPolylies.map((p) => LatLng(p.latitude, p.longitude)).toList(),
    );

    setState(() {
      _polylines.clear();
      _polylines.add(polyline);
    });
  }

  Future<void> _setPolyline(GoogleDirection direction) async {
    final String polylineIdVal = 'polyline_${_polylines.length + 1}';
    _googleMapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: direction.boundSW, northeast: direction.boundNE),
        25.0,
      ),
    );

    final polyline = Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 2,
      color: AppColors.primaryColor,
      points: direction.decodedPolylies.map((p) => LatLng(p.latitude, p.longitude)).toList(),
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    try {
      _loadingNotifier.value = true;
      _googleMapController = controller;

      final result = await _api.getDirection(
        origin: widget.originCoordinates,
        destination: widget.destinationCoordinates,
      );

      result.when(
        _setPolyline,
        (error) {},
      );
    } finally {
      _loadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.originCoordinates == null || widget.destinationCoordinates == null) {
      return _buildGoogleMapFailure();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _loadingNotifier,
      builder: (context, loading, _) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AbsorbPointer(
                absorbing: false,
                child: GoogleMap(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                  },
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  polylines: _polylines,
                  markers: _markers,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(target: LatLng(37.42796133580664, -122.085749655962)),
                ),
              ),
            ),
            if (loading)
              Center(
                child: CupertinoActivityIndicator(
                  radius: Sizes.s16.h,
                  color: AppColors.primaryColor,
                ),
              )
          ],
        );
      },
    );
  }

  Widget _buildGoogleMapFailure() {
    return Container(
      height: Sizes.s200.h,
      width: ScreenUtil().screenWidth,
      color: Colors.grey.shade50,
      alignment: Alignment.center,
      child: EmptyText(
        'Error occurred while loading map',
        color: Colors.black,
        fontSize: Sizes.s14.sp,
      ),
    );
  }
}
