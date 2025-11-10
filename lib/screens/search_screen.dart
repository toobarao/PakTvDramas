import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uielem/providers/tv_ratings_provider.dart';
import 'package:uielem/services/apiservice.dart';
import '../models/channel_drama.dart';
import '../models/channel_info.dart';
import '../models/drama_response.dart';
import '../models/search_drama.dart';
import '../models/search_history_item.dart';
import '../pages/drama_page.dart';
import '../pages/no_internet_page.dart';
import '../providers/drama_provider.dart';
import '../providers/network_provider.dart';
import '../providers/social_media_ranking_provider.dart';

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchDramaResult> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  List<SearchHistoryItem> _searchHistory = [];
  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await ApiService.instance.fetchSearchDrama(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong';
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<void> fetchSearchHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('searchHistory')
          .orderBy('searchedAt', descending: true)
          .get();

      final history = snapshot.docs
          .map((doc) => SearchHistoryItem.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() => _searchHistory = history);
    } catch (e) {
      debugPrint("Search history error: $e");
    }
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSearchHistory();
  }
  void _onTextChanged(String text) {
    if (text.trim().isNotEmpty) {
      _performSearch(text.trim());
    } else {
      setState(() {
        _searchResults = [];
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAppBar(context),
              TextField(
                controller: _searchController,
                onChanged: _onTextChanged,

      decoration: InputDecoration(
        hintText: "Type drama name here",
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            _onTextChanged(_searchController.text); // trigger search manually
            FocusScope.of(context).unfocus(); // hide keyboard if needed
          },
          child: Icon(Icons.search, color: Colors.red),
        ),
        fillColor: Theme.of(context).primaryColor.withOpacity(0.2),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),

              const SizedBox(height: 10),
               if (_searchHistory.isNotEmpty) _buildSearchHistoryChips(),
              const SizedBox(height: 16),
      
              // Loading Indicator
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
      
              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: TextStyle(color: Colors.red)),
      
              // Results List
              if (!_isLoading && _errorMessage.isEmpty)
                Expanded(
                  child: _searchResults.isEmpty
                      ? Center(

          child: Container(
            width: 300,
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme.of(context).scaffoldBackgroundColor==Colors.black?
            Image.asset('assets/images/search_logo.png'):Image.asset('assets/images/white_search.png'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Search Any Drama",style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 24,fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Explore our libraries and enjoy "
                "the drama with your family.",style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16,color: Colors.grey),textAlign: TextAlign.center,),
            )
                    ],
                  ),
          ))
                      : ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final drama = _searchResults[index];
        final thumb = "https://www.paktvdramas.pk:3060/drama-thumbnails/${drama.thumbnail.replaceAll('./assets/drama_thumbnails/', '')}";

        return GestureDetector(
          onTap: () async{

            final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final item = SearchHistoryItem(keyword:_searchController.text , searchedAt: DateTime.now());
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('searchHistory')
                    .add(item.toJson());}
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DramaPage(dramaId: drama.dramas[0].id, channelId: drama.channelId),
            ));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: thumb,
                    width: 100,
                    height: 140,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 140,
                      color: Colors.grey[300],
                      child:Image.asset("assets/images/placeholder.png"),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 140,
                      color: Colors.grey[300],
                      child: Image.asset("assets/images/placeholder.png"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    drama.dramas[0].name,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )
                ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 20,color: Colors.red,),
        ),
        const SizedBox(width: 10),
        Text("Search", style: TextStyle(fontSize: 16)),
      ],
    );
  }
  Widget _buildSearchHistoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _searchHistory.length,
        itemBuilder: (context, index) {
          final item = _searchHistory[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(item.keyword),
              avatar: const Icon(Icons.history, size: 18),
              onPressed: () {
                _searchController.text = item.keyword;

              },
            ),
          );
        },
      ),
    );
  }
}

