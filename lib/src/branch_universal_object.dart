import 'package:flutter_branch_io_plugin/src/content_meta_data.dart';

enum CONTENT_INDEX_MODE {
    PUBLIC, PRIVATE
}

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
  CONTENT_INDEX_MODE _indexMode;
  /* Any keyword associated with the content. Used for indexing */
  List<String> _keywords;
  /* Expiry date for the content and any associated links. Represented as epoch milli second */
  int _expirationInMilliSec;
  /* Index mode for  local content indexing */
  CONTENT_INDEX_MODE _localIndexMode;
  String _creationTimeStamp;

  FlutterBranchUniversalObject() {
    _metadata = FlutterContentMetaData();
    _keywords = List();
    _canonicalIdentifier = "";
    _canonicalUrl = "";
    _title = "";
    _description = "";
    _indexMode = CONTENT_INDEX_MODE.PUBLIC;
    _localIndexMode = CONTENT_INDEX_MODE.PUBLIC;
    _expirationInMilliSec = 0;
    _creationTimeStamp = DateTime.now().toLocal().toIso8601String();
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

  FlutterBranchUniversalObject setContentIndexingMode(CONTENT_INDEX_MODE indexMode) {
    this._indexMode = indexMode;
    return this;
  }

  FlutterBranchUniversalObject setLocalIndexMode(CONTENT_INDEX_MODE localIndexMode) {
    this._localIndexMode = localIndexMode;
    return this;
  }

  FlutterBranchUniversalObject addKeyWords(List<String> keywords) {
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
    return _indexMode == CONTENT_INDEX_MODE.PUBLIC;
  }

  bool isLocallyIndexable() {
    return _indexMode == CONTENT_INDEX_MODE.PUBLIC;
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

//  /**
//   * Get the keywords associated with this {@link BranchUniversalObject}
//   *
//   * @return A {@link JSONArray} with keywords associated with this {@link BranchUniversalObject}
//   */
//  JSONArray getKeywordsJsonArray() {
//    JSONArray keywordArray = new JSONArray();
//    for (String keyword : keywords_) {
//      keywordArray.put(keyword);
//    }
//    return keywordArray;
//  }

  List<String> getKeywords() {
    return _keywords;
  }

////-------------Object flattening methods--------------------//

//String convertToJsonString() {
//  try {
//    // Add all keys in plane format  initially. All known keys will be replaced with corresponding data type in the following section
//    String metadataJsonObject = _metadata.convertToJson();
//    Iterator<String> keys = metadataJsonObject.keys();
//    while (keys.hasNext()) {
//      String key = keys.next();
//      buoJsonModel.put(key, metadataJsonObject.get(key));
//    }
//    if (!TextUtils.isEmpty(title_)) {
//      buoJsonModel.put(Defines.Jsonkey.ContentTitle.getKey(), title_);
//    }
//    if (!TextUtils.isEmpty(canonicalIdentifier_)) {
//      buoJsonModel.put(Defines.Jsonkey.CanonicalIdentifier.getKey(), canonicalIdentifier_);
//    }
//    if (!TextUtils.isEmpty(canonicalUrl_)) {
//      buoJsonModel.put(Defines.Jsonkey.CanonicalUrl.getKey(), canonicalUrl_);
//    }
//    if (keywords_.size() > 0) {
//      JSONArray keyWordJsonArray = new JSONArray();
//      for (String keyword : keywords_) {
//        keyWordJsonArray.put(keyword);
//      }
//      buoJsonModel.put(Defines.Jsonkey.ContentKeyWords.getKey(), keyWordJsonArray);
//    }
//    if (!TextUtils.isEmpty(description_)) {
//      buoJsonModel.put(Defines.Jsonkey.ContentDesc.getKey(), description_);
//    }
//    if (!TextUtils.isEmpty(imageUrl_)) {
//      buoJsonModel.put(Defines.Jsonkey.ContentImgUrl.getKey(), imageUrl_);
//    }
//    if (expirationInMilliSec_ > 0) {
//      buoJsonModel.put(Defines.Jsonkey.ContentExpiryTime.getKey(), expirationInMilliSec_);
//    }
//    buoJsonModel.put(Defines.Jsonkey.PublicallyIndexable.getKey(), isPublicallyIndexable());
//    buoJsonModel.put(Defines.Jsonkey.LocallyIndexable.getKey(), isLocallyIndexable());
//    buoJsonModel.put(Defines.Jsonkey.CreationTimestamp.getKey(), creationTimeStamp_);
//
//  } catch (JSONException ignore) {
//  }
//  return buoJsonModel;
//}


//  //-------------------- Register views--------------------------//
//
//  /**
//   * Mark the content referred by this object as viewed. This increment the view count of the contents referred by this object.
//   */
//  public void registerView() {
//    registerView(null);
//  }
//
//  /**
//   * Mark the content referred by this object as viewed. This increment the view count of the contents referred by this object.
//   *
//   * @param callback An instance of {@link RegisterViewStatusListener} to listen to results of the operation
//   */
//  public void registerView(@Nullable RegisterViewStatusListener callback) {
//    if (Branch.getInstance() != null) {
//      Branch.getInstance().registerView(this, callback);
//    } else {
//      if (callback != null) {
//        callback.onRegisterViewFinished(false, new BranchError("Register view error", BranchError.ERR_BRANCH_NOT_INSTANTIATED));
//      }
//    }
//  }
//
//
//  /**
//   * <p>
//   * Callback interface for listening register content view status
//   * </p>
//   */
//  public interface RegisterViewStatusListener {
//  /**
//   * Called on finishing the the register view process
//   *
//   * @param registered A {@link boolean} which is set to true if register content view succeeded
//   * @param error      An instance of {@link BranchError} to notify any error occurred during registering a content view event.
//   *                   A null value is set if the registering content view succeeds
//   */
//  void onRegisterViewFinished(boolean registered, BranchError error);
//}
//
//
////--------------------- Create Link --------------------------//
//
///**
// * Creates a short url for the BUO synchronously.
// *
// * @param context        {@link Context} instance
// * @param linkProperties An object of {@link LinkProperties} specifying the properties of this link
// * @return A {@link String} with value of the short url created for this BUO. A long url for the BUO is returned in case link creation fails
// */
//public String getShortUrl(@NonNull Context context, @NonNull LinkProperties linkProperties) {
//  return getLinkBuilder(context, linkProperties).getShortUrl();
//}
//
///**
// * Creates a short url for the BUO synchronously.
// *
// * @param context          {@link Context} instance
// * @param linkProperties   An object of {@link LinkProperties} specifying the properties of this link
// * @param defaultToLongUrl A {@link boolean} specifies if a long url should be returned in case of link creation error
// *                         If set to false, NULL is returned in case of link creation error
// * @return A {@link String} with value of the short url created for this BUO. NULL is returned in case link creation fails
// */
//public String getShortUrl(@NonNull Context context, @NonNull LinkProperties linkProperties, boolean defaultToLongUrl) {
//  return getLinkBuilder(context, linkProperties).setDefaultToLongUrl(defaultToLongUrl).getShortUrl();
//}
//
///**
// * Creates a short url for the BUO asynchronously
// *
// * @param context        {@link Context} instance
// * @param linkProperties An object of {@link LinkProperties} specifying the properties of this link
// * @param callback       An instance of {@link io.branch.referral.Branch.BranchLinkCreateListener} to receive the results
// */
//public void generateShortUrl(@NonNull Context context, @NonNull LinkProperties linkProperties, @Nullable Branch.BranchLinkCreateListener callback) {
//  getLinkBuilder(context, linkProperties).generateShortUrl(callback);
//}
//
///**
// * Creates a short url for the BUO asynchronously.
// *
// * @param context          {@link Context} instance
// * @param linkProperties   An object of {@link LinkProperties} specifying the properties of this link
// * @param callback         An instance of {@link io.branch.referral.Branch.BranchLinkCreateListener} to receive the results
// * @param defaultToLongUrl A {@link boolean} specifies if a long url should be returned in case of link creation error
// *                         If set to false, NULL is returned in case of link creation error
// */
//public void generateShortUrl(@NonNull Context context, @NonNull LinkProperties linkProperties, @Nullable Branch.BranchLinkCreateListener callback, boolean defaultToLongUrl) {
//  getLinkBuilder(context, linkProperties).setDefaultToLongUrl(defaultToLongUrl).generateShortUrl(callback);
//}
//
//
////------------------ Share sheet -------------------------------------//
//
//public void showShareSheet(@NonNull Activity activity, @NonNull LinkProperties linkProperties, @NonNull ShareSheetStyle style, @Nullable Branch.BranchLinkShareListener callback) {
//  showShareSheet(activity, linkProperties, style, callback, null);
//}
//
//public void showShareSheet(@NonNull Activity activity, @NonNull LinkProperties linkProperties, @NonNull ShareSheetStyle style, @Nullable Branch.BranchLinkShareListener callback, Branch.IChannelProperties channelProperties) {
//  if (Branch.getInstance() == null) {  //if in case Branch instance is not created. In case of user missing create instance or BranchApp in manifest
//    if (callback != null) {
//      callback.onLinkShareResponse(null, null, new BranchError("Trouble sharing link. ", BranchError.ERR_BRANCH_NOT_INSTANTIATED));
//    } else {
//      Log.e("BranchSDK", "Sharing error. Branch instance is not created yet. Make sure you have initialised Branch.");
//    }
//  } else {
//    Branch.ShareLinkBuilder shareLinkBuilder = new Branch.ShareLinkBuilder(activity, getLinkBuilder(activity, linkProperties));
//    shareLinkBuilder.setCallback(new LinkShareListenerWrapper(callback, shareLinkBuilder, linkProperties))
//        .setChannelProperties(channelProperties)
//        .setSubject(style.getMessageTitle())
//        .setMessage(style.getMessageBody());
//
//    if (style.getCopyUrlIcon() != null) {
//      shareLinkBuilder.setCopyUrlStyle(style.getCopyUrlIcon(), style.getCopyURlText(), style.getUrlCopiedMessage());
//    }
//    if (style.getMoreOptionIcon() != null) {
//      shareLinkBuilder.setMoreOptionStyle(style.getMoreOptionIcon(), style.getMoreOptionText());
//    }
//    if (style.getDefaultURL() != null) {
//      shareLinkBuilder.setDefaultURL(style.getDefaultURL());
//    }
//    if (style.getPreferredOptions().size() > 0) {
//      shareLinkBuilder.addPreferredSharingOptions(style.getPreferredOptions());
//    }
//    if (style.getStyleResourceID() > 0) {
//      shareLinkBuilder.setStyleResourceID(style.getStyleResourceID());
//    }
//    shareLinkBuilder.setDividerHeight(style.getDividerHeight());
//    shareLinkBuilder.setAsFullWidthStyle(style.getIsFullWidthStyle());
//    shareLinkBuilder.setDialogThemeResourceID(style.getDialogThemeResourceID());
//    shareLinkBuilder.setSharingTitle(style.getSharingTitle());
//    shareLinkBuilder.setSharingTitle(style.getSharingTitleView());
//    shareLinkBuilder.setIconSize(style.getIconSize());
//
//    if (style.getIncludedInShareSheet() != null && style.getIncludedInShareSheet().size() > 0) {
//      shareLinkBuilder.includeInShareSheet(style.getIncludedInShareSheet());
//    }
//    if (style.getExcludedFromShareSheet() != null && style.getExcludedFromShareSheet().size() > 0) {
//      shareLinkBuilder.excludeFromShareSheet(style.getExcludedFromShareSheet());
//    }
//    shareLinkBuilder.shareLink();
//  }
//}
//
//private BranchShortLinkBuilder getLinkBuilder(@NonNull Context context, @NonNull LinkProperties linkProperties) {
//  BranchShortLinkBuilder shortLinkBuilder = new BranchShortLinkBuilder(context);
//  return getLinkBuilder(shortLinkBuilder, linkProperties);
//}
//
//private BranchShortLinkBuilder getLinkBuilder(@NonNull BranchShortLinkBuilder shortLinkBuilder, @NonNull LinkProperties linkProperties) {
//  if (linkProperties.getTags() != null) {
//    shortLinkBuilder.addTags(linkProperties.getTags());
//  }
//  if (linkProperties.getFeature() != null) {
//    shortLinkBuilder.setFeature(linkProperties.getFeature());
//  }
//  if (linkProperties.getAlias() != null) {
//    shortLinkBuilder.setAlias(linkProperties.getAlias());
//  }
//  if (linkProperties.getChannel() != null) {
//    shortLinkBuilder.setChannel(linkProperties.getChannel());
//  }
//  if (linkProperties.getStage() != null) {
//    shortLinkBuilder.setStage(linkProperties.getStage());
//  }
//  if (linkProperties.getCampaign() != null) {
//    shortLinkBuilder.setCampaign(linkProperties.getCampaign());
//  }
//  if (linkProperties.getMatchDuration() > 0) {
//    shortLinkBuilder.setDuration(linkProperties.getMatchDuration());
//  }
//  if (!TextUtils.isEmpty(title_)) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.ContentTitle.getKey(), title_);
//  }
//  if (!TextUtils.isEmpty(canonicalIdentifier_)) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.CanonicalIdentifier.getKey(), canonicalIdentifier_);
//  }
//  if (!TextUtils.isEmpty(canonicalUrl_)) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.CanonicalUrl.getKey(), canonicalUrl_);
//  }
//  JSONArray keywords = getKeywordsJsonArray();
//  if (keywords.length() > 0) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.ContentKeyWords.getKey(), keywords);
//  }
//  if (!TextUtils.isEmpty(description_)) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.ContentDesc.getKey(), description_);
//  }
//  if (!TextUtils.isEmpty(imageUrl_)) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.ContentImgUrl.getKey(), imageUrl_);
//  }
//  if (expirationInMilliSec_ > 0) {
//    shortLinkBuilder.addParameters(Defines.Jsonkey.ContentExpiryTime.getKey(), "" + expirationInMilliSec_);
//  }
//  shortLinkBuilder.addParameters(Defines.Jsonkey.PublicallyIndexable.getKey(), "" + isPublicallyIndexable());
//  JSONObject metadataJson = metadata_.convertToJson();
//  try {
//    Iterator<String> keys = metadataJson.keys();
//    while (keys.hasNext()) {
//      String key = keys.next();
//      shortLinkBuilder.addParameters(key, metadataJson.get(key));
//    }
//  } catch (JSONException e) {
//  e.printStackTrace();
//  }
//  HashMap<String, String> controlParam = linkProperties.getControlParams();
//  for (String key : controlParam.keySet()) {
//  shortLinkBuilder.addParameters(key, controlParam.get(key));
//  }
//  return shortLinkBuilder;
//}
//
///**
// * Get the {@link BranchUniversalObject} associated with the latest deep linking. This should retrieve the
// * exact object used for creating the deep link. This should be called only after initialising Branch Session.
// *
// * @return A {@link BranchUniversalObject} used to create the deep link that started the this app session.
// * Null is returned if this session is not started by Branch link click
// */
//public static BranchUniversalObject getReferredBranchUniversalObject() {
//  BranchUniversalObject branchUniversalObject = null;
//  Branch branchInstance = Branch.getInstance();
//  try {
//    if (branchInstance != null && branchInstance.getLatestReferringParams() != null) {
//      // Check if link clicked. Unless deep link debug enabled return null if there is no link click
//      if (branchInstance.getLatestReferringParams().has("+clicked_branch_link") && branchInstance.getLatestReferringParams().getBoolean("+clicked_branch_link")) {
//        branchUniversalObject = createInstance(branchInstance.getLatestReferringParams());
//      }
//      // If debug params are set then send BUO object even if link click is false
//      else if (branchInstance.getDeeplinkDebugParams() != null && branchInstance.getDeeplinkDebugParams().length() > 0) {
//        branchUniversalObject = createInstance(branchInstance.getLatestReferringParams());
//      }
//    }
//  } catch (Exception ignore) {
//  }
//  return branchUniversalObject;
//}
//
///**
// * Creates a new BranchUniversalObject with the data provided by {@link JSONObject}.
// *
// * @param jsonObject {@link JSONObject} to create the BranchUniversalObject
// * @return A {@link BranchUniversalObject} corresponding to the Json data passed in
// */
//public static BranchUniversalObject createInstance(JSONObject jsonObject) {
//
//  BranchUniversalObject branchUniversalObject = null;
//  try {
//    branchUniversalObject = new BranchUniversalObject();
//    BranchUtil.JsonReader jsonReader = new BranchUtil.JsonReader(jsonObject);
//    branchUniversalObject.title_ = jsonReader.readOutString(Defines.Jsonkey.ContentTitle.getKey());
//    branchUniversalObject.canonicalIdentifier_ = jsonReader.readOutString(Defines.Jsonkey.CanonicalIdentifier.getKey());
//    branchUniversalObject.canonicalUrl_ = jsonReader.readOutString(Defines.Jsonkey.CanonicalUrl.getKey());
//    branchUniversalObject.description_ = jsonReader.readOutString(Defines.Jsonkey.ContentDesc.getKey());
//    branchUniversalObject.imageUrl_ = jsonReader.readOutString(Defines.Jsonkey.ContentImgUrl.getKey());
//    branchUniversalObject.expirationInMilliSec_ = jsonReader.readOutLong(Defines.Jsonkey.ContentExpiryTime.getKey());
//    JSONArray keywordJsonArray = null;
//    Object keyWordArrayObject = jsonReader.readOut(Defines.Jsonkey.ContentKeyWords.getKey());
//    if (keyWordArrayObject instanceof JSONArray) {
//      keywordJsonArray = (JSONArray) keyWordArrayObject;
//    } else if (keyWordArrayObject instanceof String) {
//      keywordJsonArray = new JSONArray((String) keyWordArrayObject);
//    }
//    if (keywordJsonArray != null) {
//      for (int i = 0; i < keywordJsonArray.length(); i++) {
//        branchUniversalObject.keywords_.add((String) keywordJsonArray.get(i));
//  }
//  }
//  Object indexableVal = jsonReader.readOut(Defines.Jsonkey.PublicallyIndexable.getKey());
//  if (indexableVal instanceof Boolean) {
//  branchUniversalObject.indexMode_ = (Boolean) indexableVal ? CONTENT_INDEX_MODE.PUBLIC : CONTENT_INDEX_MODE.PRIVATE;
//  } else if (indexableVal instanceof Integer) {
//  // iOS compatibility issue. iOS send 0/1 instead of true or false
//  branchUniversalObject.indexMode_ = (Integer) indexableVal == 1 ? CONTENT_INDEX_MODE.PUBLIC : CONTENT_INDEX_MODE.PRIVATE;
//  }
//  branchUniversalObject.localIndexMode_ = jsonReader.readOutBoolean(Defines.Jsonkey.LocallyIndexable.getKey()) ? CONTENT_INDEX_MODE.PUBLIC : CONTENT_INDEX_MODE.PRIVATE;
//  branchUniversalObject.creationTimeStamp_ = jsonReader.readOutLong(Defines.Jsonkey.CreationTimestamp.getKey());
//
//  branchUniversalObject.metadata_ = ContentMetadata.createFromJson(jsonReader);
//  // PRS : Handling a  backward compatibility issue here. Previous version of BUO Allows adding metadata key value pairs to the Object.
//  // If the Json is received from a previous version of BUO it may have metadata set in the object. Adding them to custom metadata for now.
//  // Please note that #getMetadata() is deprecated and #getContentMetadata() should be the new way of getting metadata
//  JSONObject pendingJson = jsonReader.getJsonObject();
//  Iterator<String> keys = pendingJson.keys();
//  while (keys.hasNext()) {
//  String key = keys.next();
//  branchUniversalObject.metadata_.addCustomMetadata(key, pendingJson.optString(key));
//  }
//
//  } catch (Exception ignore) {
//  }
//  return branchUniversalObject;
//}
//
////---------------------Marshaling and Unmarshaling----------//
//@Override
//public int describeContents() {
//  return 0;
//}
//
//public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
//public BranchUniversalObject createFromParcel(Parcel in) {
//return new BranchUniversalObject(in);
//}
//
//public BranchUniversalObject[] newArray(int size) {
//  return new BranchUniversalObject[size];
//}
//};
//
//@Override
//public void writeToParcel(Parcel dest, int flags) {
//  dest.writeLong(creationTimeStamp_);
//  dest.writeString(canonicalIdentifier_);
//  dest.writeString(canonicalUrl_);
//  dest.writeString(title_);
//  dest.writeString(description_);
//  dest.writeString(imageUrl_);
//  dest.writeLong(expirationInMilliSec_);
//  dest.writeInt(indexMode_.ordinal());
//  dest.writeSerializable(keywords_);
//  dest.writeParcelable(metadata_, flags);
//  dest.writeInt(localIndexMode_.ordinal());
//}
//
//private BranchUniversalObject(Parcel in) {
//this();
//creationTimeStamp_ = in.readLong();
//canonicalIdentifier_ = in.readString();
//canonicalUrl_ = in.readString();
//title_ = in.readString();
//description_ = in.readString();
//imageUrl_ = in.readString();
//expirationInMilliSec_ = in.readLong();
//indexMode_ = CONTENT_INDEX_MODE.values()[in.readInt()];
//@SuppressWarnings("unchecked")
//ArrayList<String> keywordsTemp = (ArrayList<String>) in.readSerializable();
//if (keywordsTemp != null) {
//keywords_.addAll(keywordsTemp);
//}
//metadata_ = in.readParcelable(ContentMetadata.class.getClassLoader());
//localIndexMode_ = CONTENT_INDEX_MODE.values()[in.readInt()];
//}
//
///**
// * Class for intercepting share sheet events to report auto events on BUO
// */
//private class LinkShareListenerWrapper implements Branch.BranchLinkShareListener {
//  private final Branch.BranchLinkShareListener originalCallback_;
//  private final Branch.ShareLinkBuilder shareLinkBuilder_;
//  private final LinkProperties linkProperties_;
//
//  LinkShareListenerWrapper(Branch.BranchLinkShareListener originalCallback, Branch.ShareLinkBuilder shareLinkBuilder, LinkProperties linkProperties) {
//    originalCallback_ = originalCallback;
//    shareLinkBuilder_ = shareLinkBuilder;
//    linkProperties_ = linkProperties;
//  }
//
//  @Override
//  public void onShareLinkDialogLaunched() {
//    if (originalCallback_ != null) {
//      originalCallback_.onShareLinkDialogLaunched();
//    }
//  }
//
//  @Override
//  public void onShareLinkDialogDismissed() {
//    if (originalCallback_ != null) {
//      originalCallback_.onShareLinkDialogDismissed();
//    }
//  }
//
//  @Override
//  public void onLinkShareResponse(String sharedLink, String sharedChannel, BranchError error) {
//    HashMap<String, String> metaData = new HashMap<>();
//    if (error == null) {
//      metaData.put(Defines.Jsonkey.SharedLink.getKey(), sharedLink);
//    } else {
//      metaData.put(Defines.Jsonkey.ShareError.getKey(), error.getMessage());
//    }
//    //noinspection deprecation
//    userCompletedAction(BRANCH_STANDARD_EVENT.SHARE.getName(), metaData);
//    if (originalCallback_ != null) {
//      originalCallback_.onLinkShareResponse(sharedLink, sharedChannel, error);
//    }
//  }
//
//  @Override
//  public void onChannelSelected(String channelName) {
//    if (originalCallback_ != null) {
//      originalCallback_.onChannelSelected(channelName);
//    }
//    if (originalCallback_ instanceof Branch.ExtendedBranchLinkShareListener) {
//      if (((Branch.ExtendedBranchLinkShareListener) originalCallback_).onChannelSelected(channelName, BranchUniversalObject.this, linkProperties_)) {
//        shareLinkBuilder_.setShortLinkBuilderInternal(getLinkBuilder(shareLinkBuilder_.getShortLinkBuilder(), linkProperties_));
//      }
//    }
//  }

//}

}