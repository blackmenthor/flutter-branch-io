import 'dart:convert';

enum FlutterBuoProductCondition {
  OTHER, NEW, GOOD, FAIR, POOR, USED, REFURBISHED, EXCELLENT
}

enum FlutterBranchIOCurrencyType {
  IDR, USD
}

enum FlutterBranchIOProductCategory {
  // TODO: COMPLETE
  HOME_AND_GARDEN
}

const String QUANTITY_JSON = "\$quantity";
const String PRICE_JSON = "\$price";
const String CURRENCY_JSON = "\$currency";
const String SKU_JSON = "\$sku";
const String PRODUCT_NAME_JSON = "\$product_name";
const String PRODUCT_BRAND_JSON = "\$product_brand";
const String PRODUCT_CATEGORY_JSON = "\$product_category";
const String CONDITION_JSON = "\$condition";
const String PRODUCT_VARIANT_JSON = "\$product_variant";
const String ADDRESS_STREET_JSON = "\$address_street";
const String ADDRESS_CITY_JSON = "\$address_city";
const String ADDRESS_REGION_JSON = "\$address_region";
const String ADDRESS_COUNTRY_JSON = "\$address_country";
const String ADDRESS_POSTAL_JSON = "\$address_postal_code";
const String LATITUDE_JSON = "\$latitude";
const String LONGITUDE_JSON = "\$longitude";
const String IMAGE_CAPTION_JSON = "\$image_captions";

class FlutterContentMetaData {

  /// Quantity of the thing associated with the qualifying content item
  int $quantity;
  /// Any price associated with the qualifying content item
  int $price;
  /// Currency type associated with the price
  FlutterBranchIOCurrencyType $currencyType;
  /// Holds any associated store keeping unit
  String $sku;
  /// Name of any product specified by this metadata
  String $productName;
  /// Any brand name associated with this metadata
  String $productBrand;
  /// Category of product if this metadata is for a product
  /// Value should be one of the enumeration from {@link ProductCategory}
  FlutterBranchIOProductCategory $productCategory;
  /// Condition of the product item. Value is one of the enum constants from {@link CONDITION}
  FlutterBuoProductCondition $condition;
  /// Variant of product if this metadata is for a product
  String $productVariant;
  /// Street address associated with the qualifying content item
  String $addressStreet;
  /// City name associated with the qualifying content item
  String $addressCity;
  /// Region or province name associated with the qualifying content item
  String $addressRegion;
  /// Country name associated with the qualifying content item
  String $addressCountry;
  /// Postal code associated with the qualifying content item
  String $addressPostalCode;
  /// Latitude value  associated with the qualifying content item
  double $latitude;
  /// Latitude value  associated with the qualifying content item
  double $longitude;

  List<dynamic> $imageCaptions;
  Map<String, dynamic> $customMetadata;

  FlutterContentMetaData() {
    this.$customMetadata = {};
  }

  FlutterContentMetaData.fromJson(String json) {
    try {
      double lat = 0.0;
      double lng = 0.0;
      Map<String, dynamic> map = jsonDecode(json);

      if (map[QUANTITY_JSON] != null) setQuantity(map[QUANTITY_JSON]);
      if (map[PRICE_JSON] != null) setPrice(map[PRICE_JSON], getCurrencyType(map[CURRENCY_JSON]));
      if (map[SKU_JSON] != null) setSku(map[SKU_JSON]);
      if (map[PRODUCT_NAME_JSON] != null) setProductName(map[PRODUCT_NAME_JSON]);
      if (map[PRODUCT_BRAND_JSON] != null) setProductBrand(map[PRODUCT_BRAND_JSON]);
      if (map[PRODUCT_CATEGORY_JSON] != null) setProductCategory(getProductCategory(map[PRODUCT_CATEGORY_JSON]));
      if (map[PRODUCT_VARIANT_JSON] != null) setProductVariant(map[PRODUCT_VARIANT_JSON]);
      if (map[CONDITION_JSON] != null) setProductCondition(getProductCondition(map[CONDITION_JSON]));

      if (map[ADDRESS_STREET_JSON] != null) setAddress(street: map[ADDRESS_STREET_JSON]);
      if (map[ADDRESS_CITY_JSON] != null) setAddress(city: map[ADDRESS_CITY_JSON]);
      if (map[ADDRESS_REGION_JSON] != null) setAddress(region: map[ADDRESS_REGION_JSON]);
      if (map[ADDRESS_COUNTRY_JSON] != null) setAddress(country: map[ADDRESS_COUNTRY_JSON]);
      if (map[ADDRESS_POSTAL_JSON] != null) setAddress(postalCode: map[ADDRESS_POSTAL_JSON]);

      if (map[LATITUDE_JSON] != null) lat = map[LATITUDE_JSON];
      if (map[LONGITUDE_JSON] != null) lng = map[LONGITUDE_JSON];
      if (lat != 0.0 || lng != 0.0) setLocation(lat, lng);

      if (map[IMAGE_CAPTION_JSON] != null) addImageCaptions(map[IMAGE_CAPTION_JSON]);
    } catch (e) {
      print("ERROR PARSING METADATA ${e.toString()}");
    }
  }

  FlutterBuoProductCondition getProductCondition(String productCondition) {
    if (productCondition == null) return FlutterBuoProductCondition.OTHER;
    switch (productCondition) {
      case "OTHER":
        return FlutterBuoProductCondition.OTHER;
      case "NEW":
        return FlutterBuoProductCondition.NEW;
      case "GOOD":
        return FlutterBuoProductCondition.GOOD;
      case "FAIR":
        return FlutterBuoProductCondition.FAIR;
      case "POOR":
        return FlutterBuoProductCondition.POOR;
      case "USED":
        return FlutterBuoProductCondition.USED;
      case "REFURBISHED":
        return FlutterBuoProductCondition.REFURBISHED;
      case "EXCELLENT":
        return FlutterBuoProductCondition.EXCELLENT;
      default:
        return FlutterBuoProductCondition.OTHER;
    }
  }

  String getProductConditionString(FlutterBuoProductCondition productCondition) {
    if (productCondition == null) return "OTHER";
    switch (productCondition) {
      case FlutterBuoProductCondition.OTHER:
        return "OTHER";
      case FlutterBuoProductCondition.NEW:
        return "NEW";
      case FlutterBuoProductCondition.GOOD:
        return "GOOD";
      case FlutterBuoProductCondition.FAIR:
        return "FAIR";
      case FlutterBuoProductCondition.POOR:
        return "POOR";
      case FlutterBuoProductCondition.USED:
        return "USED";
      case FlutterBuoProductCondition.REFURBISHED:
        return "REFURBISHED";
      case FlutterBuoProductCondition.EXCELLENT:
        return "EXCELLENT";
      default:
        return "OTHER";
    }
  }

  FlutterBranchIOProductCategory getProductCategory(String productCategory) {
    // TODO: COMPLETE
    if (productCategory == null) return FlutterBranchIOProductCategory.HOME_AND_GARDEN;
    switch (productCategory) {
      case "Home & Garden":
        return FlutterBranchIOProductCategory.HOME_AND_GARDEN;
      default:
        return FlutterBranchIOProductCategory.HOME_AND_GARDEN;
    }
  }

   String getProductCategoryString(FlutterBranchIOProductCategory productCategory) {
    // TODO: COMPLETE
    if (productCategory == null) return "Home & Garden";
    switch (productCategory) {
      case FlutterBranchIOProductCategory.HOME_AND_GARDEN:
        return "Home & Garden";
      default:
        return "Home & Garden";
    }
  }

  FlutterBranchIOCurrencyType getCurrencyType(String currencyType) {
    if (currencyType == null) return FlutterBranchIOCurrencyType.IDR;
    switch (currencyType) {
      case "IDR":
        return FlutterBranchIOCurrencyType.IDR;
      case "USD":
        return FlutterBranchIOCurrencyType.USD;
      default:
        return FlutterBranchIOCurrencyType.IDR;
    }
  }

  String getCurrencyTypeString(FlutterBranchIOCurrencyType currencyType) {
    if (currencyType == null) return "IDR";
    switch (currencyType) {
      case FlutterBranchIOCurrencyType.IDR:
        return "IDR";
      case FlutterBranchIOCurrencyType.USD:
        return "USD";
      default:
        return "IDR";
    }
  }

  FlutterContentMetaData addImageCaptions(List<dynamic> captions) {
  this.$imageCaptions = captions;
  return this;
  }
  
  FlutterContentMetaData addCustomMetadata(String key, dynamic value) {
    $customMetadata[key] = value;
    return this;
  }

  FlutterContentMetaData setQuantity(int quantity) {
    this.$quantity = quantity;
    return this;
  }

  FlutterContentMetaData setAddress({String street, String city, String region, String country, String postalCode }) {
    if (street != null) this.$addressStreet = street;
    if (city != null) this.$addressCity = city;
    if (region != null) this.$addressRegion = region;
    if (country != null) this.$addressCountry = country;
    if (postalCode != null) this.$addressPostalCode = postalCode;
    return this;
  }

  FlutterContentMetaData setLocation(double latitude, double longitude) {
    this.$latitude = latitude;
    this.$longitude = longitude;
    return this;
  }

  FlutterContentMetaData setPrice(int price, FlutterBranchIOCurrencyType currency) {
    this.$price = price;
    this.$currencyType = currency;
    return this;
  }

  FlutterContentMetaData setProductBrand(String productBrand) {
    this.$productBrand = productBrand;
    return this;
  }

  FlutterContentMetaData setProductCategory(FlutterBranchIOProductCategory productCategory) {
    this.$productCategory = productCategory;
    return this;
  }

  FlutterContentMetaData setProductCondition(FlutterBuoProductCondition productCondition) {
    this.$condition = productCondition;
    return this;
  }

  FlutterContentMetaData setProductName(String productName) {
    this.$productName = productName;
    return this;
  }

  FlutterContentMetaData setProductVariant(String productVariant) {
    this.$productVariant = productVariant;
    return this;
  }

  FlutterContentMetaData setSku(String sku) {
    this.$sku = sku;
    return this;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> ret = Map<String, dynamic>();
    if (this.$quantity != null) ret[QUANTITY_JSON] = this.$quantity;
    if (this.$price != null) ret[PRICE_JSON] = this.$price;

    if (this.$currencyType != null) ret[CURRENCY_JSON] = getCurrencyTypeString(this.$currencyType);

    if (this.$sku != null) ret[SKU_JSON] = this.$sku;
    if (this.$productName != null) ret[PRODUCT_NAME_JSON] = this.$productName;
    if (this.$productBrand != null) ret[PRODUCT_BRAND_JSON] = this.$productBrand;

    if (this.$productCategory != null) ret[PRODUCT_CATEGORY_JSON] = getProductCategoryString(this.$productCategory);
    if (this.$condition != null) ret[CONDITION_JSON] = getProductConditionString(this.$condition);

    if (this.$productVariant != null) ret[PRODUCT_VARIANT_JSON] = this.$productVariant;
    if (this.$addressStreet != null) ret[ADDRESS_STREET_JSON] = this.$addressStreet;
    if (this.$addressCity != null) ret[ADDRESS_CITY_JSON] = this.$addressCity;
    if (this.$addressRegion != null) ret[ADDRESS_REGION_JSON] = this.$addressRegion;
    if (this.$addressCountry != null) ret[ADDRESS_COUNTRY_JSON] = this.$addressCountry;
    if (this.$addressPostalCode != null) ret[ADDRESS_POSTAL_JSON] = this.$addressPostalCode;
    if (this.$latitude != null) ret[LATITUDE_JSON] = this.$latitude;
    if (this.$longitude != null) ret[LONGITUDE_JSON] = this.$longitude;
    if (this.$imageCaptions != null) ret[IMAGE_CAPTION_JSON] = this.$imageCaptions;

    return ret;
  }

}