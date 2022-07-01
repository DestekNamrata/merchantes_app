import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodbank_marchantise_app/utils/images.dart';
import 'package:foodbank_marchantise_app/utils/size_config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';



class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key? key, required this.url}) : super(key: key);

  @override
  State createState() => FullPhotoScreenState();
}

class FullPhotoScreenState extends State<FullPhotoScreen> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:
    CachedNetworkImage(
      imageUrl: widget.url,
      // imageUrl: "https://tomato.restaurant/storage/app/20220629193058_16.jpeg",
      imageBuilder: (context,
          imageProvider) =>
          Container(
            height: SizeConfig
                .screenWidth! /
                5,
            width: SizeConfig
                .screenWidth! /
                5,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius
                    .circular(
                    10),
                image: DecorationImage(
                    image:
                    imageProvider,
                    fit: BoxFit
                        .fill)),
          ),
      placeholder: (context,
          url) =>
          Shimmer.fromColors(
            baseColor:
            Colors.grey[300]!,
            highlightColor:
            Colors.grey[400]!,
            child: Container(
                width: SizeConfig
                    .screenWidth! /
                    4,
                height: SizeConfig
                    .screenWidth! /
                    4,
                decoration:
                BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius
                          .circular(
                          10.0),
                      bottomLeft: Radius
                          .circular(
                          10.0)),
                ),
                child: Image(
                    image: AssetImage(
                        Images
                            .shimmerImage))),
          ),
      errorWidget: (context,
          url, error) =>
          Icon(Icons.error),
    ),);
  }
}