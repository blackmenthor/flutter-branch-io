import 'package:flutter_branch_io_plugin/src/models/content_meta_data.dart';
import 'dart:convert';


enum BUO_CONTENT_INDEX_MODE {
    PUBLIC, PRIVATE
}

const String TITLE_JSON = "\$og_title";
const String CANONICAL_IDENTIFIER_JSON = "\$canonical_identifier";
const String CANONICAL_URL_JSON = "\$canonical_url";
const String KEYWORDS_JSON = "\$keywords";
const String DESCRIPTION_JSON = "\$og_description";
const String IMAGE_URL_JSON = "\$og_image_url";
const String EXPIRATION_DATE_JSON = "\$exp_date";
const String PUBLICLY_INDEXABLE_JSON = "\$publicly_indexable";
const String LOCALLY_INDEXABLE_JSON = "\$locally_indexable";
const String CREATION_DATE_JSON = "\$creation_timestamp";

class FlutterBranchUniversalObject {

  /* Canonical identifier for the content referred. */
  String _canonicalIdentifier;
  /* Canonical url for the content referred. This would be the corresponding website URL */
  String _canonicalUrl;
  /* Title for the content referred by BranchUniversalObject */
  String _title;
  /* Description for the content referred */
  String _description;
  /* An image url associated with the content referred */
  String _imageUrl;
  /* Meta data provided for the content. {@link ContentMetadata} object holds the metadata for this content */
  FlutterContentMetaData _metadata;
  /* Content index mode */
  BUO_CONTENT_INDEX_MODE _indexMode;
  /* Any keyword associated with the content. Used for indexing */
  List<dynamic> _keywords;
  /* Expiry date for the content and any associated links. Represented as epoch milli second */
  int _expirationInMilliSec;
  /* Index mode for  local content indexing */
  BUO_CONTENT_INDEX_MODE _localIndexMode;
  int _creationTimeStamp;

  FlutterBranchUniversalObject() {
    _metadata = FlutterContentMetaData();
    _keywords = List();
    _canonicalIdentifier = "";
    _canonicalUrl = "";
    _title = "";
    _description = "";
    _indexMode = BUO_CONTENT_INDEX_MODE.PUBLIC;
    _localIndexMode = BUO_CONTENT_INDEX_MODE.PUBLIC;
    _creationTimeStamp = DateTime.now().millisecondsSinceEpoch;
  }

  FlutterBranchUniversalObject.fromJson(String json) {
    try {
      this._keywords = List();
      Map<String, dynamic> map = jsonDecode(json);
      FlutterContentMetaData contentMetaData = FlutterContentMetaData.fromJson(json);

      bool publiclyIndexable = map[PUBLICLY_INDEXABLE_JSON] ?? true;
      bool locallyIndexable = map[LOCALLY_INDEXABLE_JSON] ?? true;

      if (map[TITLE_JSON] != null) setTitle(map[TITLE_JSON]);
      if (map[CANONICAL_IDENTIFIER_JSON] != null) setCanonicalIdentifier(map[CANONICAL_IDENTIFIER_JSON]);
      if (map[CANONICAL_URL_JSON] != null) setCanonicalUrl(map[CANONICAL_URL_JSON]);
      if (map[KEYWORDS_JSON] != null) addKeyWords(map[KEYWORDS_JSON]);
      if (map[DESCRIPTION_JSON] != null) setContentDescription(map[DESCRIPTION_JSON]);
      if (map[IMAGE_URL_JSON] != null) setContentImageUrl(map[IMAGE_URL_JSON]);
      setContentIndexingMode(publiclyIndexable
          ? BUO_CONTENT_INDEX_MODE.PUBLIC
          : BUO_CONTENT_INDEX_MODE.PRIVATE);
      setLocalIndexMode(locallyIndexable
          ? BUO_CONTENT_INDEX_MODE.PUBLIC
          : BUO_CONTENT_INDEX_MODE.PRIVATE);
      if (map[EXPIRATION_DATE_JSON] != null) setContentExpiration(
          DateTime.fromMillisecondsSinceEpoch(map[EXPIRATION_DATE_JSON]));
      if (map[CREATION_DATE_JSON] != null) this._creationTimeStamp = map[CREATION_DATE_JSON];
      setContentMetadata(contentMetaData);
    } catch (e) {
      print("ERROR IN PROCESSING BUO ${e.toString()}");
    }
  }

  FlutterBranchUniversalObject setCanonicalIdentifier(String canonicalIdentifier) {
    this._canonicalIdentifier = canonicalIdentifier;
    return this;
  }

  FlutterBranchUniversalObject setCanonicalUrl(String canonicalUrl) {
    this._canonicalUrl = canonicalUrl;
    return this;
  }

  FlutterBranchUniversalObject setTitle(String title) {
    this._title = title;
    return this;
  }

  FlutterBranchUniversalObject setContentDescription(String description) {
    this._description = description;
    return this;
  }

  FlutterBranchUniversalObject setContentImageUrl(String imageUrl) {
    this._imageUrl = imageUrl;
    return this;
  }

  FlutterBranchUniversalObject setContentMetadata(FlutterContentMetaData metadata) {
    this._metadata = metadata;
    return this;
  }

  FlutterBranchUniversalObject setContentIndexingMode(BUO_CONTENT_INDEX_MODE indexMode) {
    this._indexMode = indexMode;
    return this;
  }

  FlutterBranchUniversalObject setLocalIndexMode(BUO_CONTENT_INDEX_MODE localIndexMode) {
    this._localIndexMode = localIndexMode;
    return this;
  }

  FlutterBranchUniversalObject addKeyWords(List<dynamic> keywords) {
    this._keywords.addAll(keywords);
    return this;
  }

  FlutterBranchUniversalObject addKeyWord(String keyword) {
    this._keywords.add(keyword);
    return this;
  }

  FlutterBranchUniversalObject setContentExpiration(DateTime expirationDate) {
    this._expirationInMilliSec = expirationDate.millisecondsSinceEpoch;
    return this;
  }

  bool isPublicallyIndexable() {
    return _indexMode == BUO_CONTENT_INDEX_MODE.PUBLIC;
  }

  bool isLocallyIndexable() {
    return _localIndexMode == BUO_CONTENT_INDEX_MODE.PUBLIC;
  }

  FlutterContentMetaData getContentMetadata() {
    return _metadata;
  }

  int getExpirationTime() {
    return _expirationInMilliSec;
  }

  String getCanonicalIdentifier() {
    return _canonicalIdentifier;
  }

  String getCanonicalUrl() {
    return _canonicalUrl;
  }

  String getDescription() {
    return _description;
  }

  String getImageUrl() {
    return _imageUrl;
  }


  String getTitle() {
    return _title;
  }

  List<dynamic> getKeywords() {
    return _keywords;
  }

  String toJson() {
    Map<String, dynamic> ret = <String, dynamic>{};
    if (this.getTitle() != null && this.getTitle().isNotEmpty) ret[TITLE_JSON] = this.getTitle();
    if (this.getCanonicalIdentifier() != null && this.getCanonicalIdentifier().isNotEmpty) ret[CANONICAL_IDENTIFIER_JSON] = this.getCanonicalIdentifier();
    if (this.getCanonicalUrl() != null && this.getCanonicalUrl().isNotEmpty) ret[CANONICAL_URL_JSON] = this.getCanonicalUrl();
    if (getKeywords().isNotEmpty) ret[KEYWORDS_JSON] = this.getKeywords();
    if (getDescription() != null && _description.isNotEmpty) ret[DESCRIPTION_JSON] = this.getDescription();
    if (getImageUrl() != null) ret[IMAGE_URL_JSON] = this.getImageUrl();
    if (getExpirationTime() != null) ret[EXPIRATION_DATE_JSON] = this.getExpirationTime();
    ret[PUBLICLY_INDEXABLE_JSON] = this.isPublicallyIndexable();
    ret[LOCALLY_INDEXABLE_JSON] = this.isLocallyIndexable();
    ret[CREATION_DATE_JSON] = this._creationTimeStamp;

    final metaDataMap = this._metadata.toMap();
    if (metaDataMap.isNotEmpty) ret.addAll(metaDataMap);

    return jsonEncode(ret);
  }

}