class FlutterLinkProperties {

  List<String> _tags;
  String _feature;
  String _alias;
  String _stage;
  int _matchDuration;
  Map<String, dynamic> _controlParams;
  String _channel;
  String _campaign;

  FlutterLinkProperties() {
    _tags = List<String>();
    _feature = "Share";
    _controlParams = {};
    _alias = "";
    _stage = "";
    _matchDuration = 0;
    _channel = "";
    _campaign = "";
  }

  String getCampaign() {
    return this._campaign;
  }

  FlutterLinkProperties setCampaign(String campaign) {
    _campaign = campaign;
    return this;
  }

  String getChannel() {
    return this._channel;
  }

  FlutterLinkProperties setChannel(String channel) {
    _channel = channel;
    return this;
  }

  Map<String, dynamic> getControlParams() {
    return this._controlParams;
  }

  FlutterLinkProperties addControlParam(String key, dynamic value){
    this._controlParams[key] = value;
    return this;
  }

  int getMatchDuration() {
    return this._matchDuration;
  }

  FlutterLinkProperties setMatchDuration(int matchDuration) {
    _matchDuration = matchDuration;
    return this;
  }

  String getStage() {
    return this._stage;
  }

  FlutterLinkProperties setStage(String stage) {
    _stage = stage;
    return this;
  }

  String getAlias() {
    return this._alias;
  }

  FlutterLinkProperties setAlias(String alias) {
    _alias = alias;
    return this;
  }

  String getFeature() {
    return this._feature;
  }

  FlutterLinkProperties setFeature(String feature) {
    _feature = feature;
    return this;
  }

  List<String> getTags() {
    return this._tags;
  }

  FlutterLinkProperties addTags(String tag) {
    _tags.add(tag);
    return this;
  }

  FlutterLinkProperties addAllTag(List<String> tags) {
    _tags = tags;
    return this;
  }

}