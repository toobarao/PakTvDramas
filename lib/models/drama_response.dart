import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uielem/models/recommendations.dart';
import 'package:uielem/models/tv_rating.dart';

import 'latest_dramas.dart';




class DramaResponse {
  final List<LatestDramas> latestDramas;
  final List<Recommendations> yourRecommendations;
  final List<Recommendations> ourRecommendations;
  final List<TvRating> tvRatings;
  final List<TvRating> socialRatings;

  DramaResponse({
    required this.latestDramas,
    required this.yourRecommendations,
    required this.ourRecommendations,
    required this.tvRatings,
    required this.socialRatings,
  });

  factory DramaResponse.fromJson(Map<String, dynamic> json) {
    return DramaResponse(
      latestDramas: (json['latestDramas'] as List<dynamic>?)
          ?.map((item) => LatestDramas.fromJson(item))
          .toList()??[],
      yourRecommendations: (json['your_recommendation'] as List<dynamic>?)
          ?.map((item) => Recommendations.fromJson(item))
          .toList()??[],
      ourRecommendations: (json['our_recommendation'] as List<dynamic>?)
          ?.map((item) => Recommendations.fromJson(item))
          .toList()??[],
      tvRatings: (json['tv_rating'] as List<dynamic>?)
          ?.map((item) => TvRating.fromJson(item))
          .toList()??[],
      socialRatings: (json['social_rating'] as List<dynamic>?)
          ?.map((item) => TvRating.fromJson(item))
          .toList()??[],
    );
  }
}











