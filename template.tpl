___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Platform Array Rewrite | Ventastic Solutions",
  "description": "Rewrites the EEC/GA4 Items array for different marketing platforms.\n\nMade by Jorg van de Ven | Ventastic Solutions.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "mapValues",
    "displayName": "Select data source",
    "radioItems": [
      {
        "value": "auto",
        "displayValue": "Automatically read from dataLayer"
      },
      {
        "value": "select",
        "displayValue": "Select e-commerce variable",
        "help": "Select a variable that contains the products or items array (e.g. ecommerce.detail.products or ecommerce.items)",
        "subParams": [
          {
            "type": "SELECT",
            "name": "manual",
            "displayName": "",
            "macrosInSelect": true,
            "selectItems": [],
            "simpleValueType": true
          }
        ]
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "platformGroup",
    "displayName": "Select platform",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "RADIO",
        "name": "platform",
        "displayName": "Rewrite EEC/Items dataLayer to...",
        "radioItems": [
          {
            "value": "fb",
            "displayValue": "Facebook contents"
          },
          {
            "value": "pt",
            "displayValue": "Pinterest line items"
          },
          {
            "value": "tk",
            "displayValue": "Tiktok product array",
            "subParams": [
              {
                "type": "SELECT",
                "name": "contentType",
                "displayName": "Content Type",
                "macrosInSelect": false,
                "selectItems": [
                  {
                    "value": "product",
                    "displayValue": "product"
                  },
                  {
                    "value": "product_group",
                    "displayValue": "product_group"
                  }
                ],
                "simpleValueType": true,
                "help": "Select the type of content for your event. This can either be \u0027product\u0027 or \u0027product_group\u0027.",
                "enablingConditions": [
                  {
                    "paramName": "platform",
                    "paramValue": "tk",
                    "type": "EQUALS"
                  }
                ]
              },
              {
                "type": "TEXT",
                "name": "currency",
                "displayName": "currency",
                "simpleValueType": true
              }
            ],
            "help": ""
          }
        ],
        "simpleValueType": true
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "CreatorGroup",
    "displayName": "Creator",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "CreatorLabel",
        "displayName": "Made by \u003cstrong\u003e\u003ca href\u003d\"https://www.linkedin.com/in/jorgvandeven/\"\u003eJorg van de Ven\u003c/a\u003e\u003c/strong\u003e | \u003cstrong\u003e\u003ca href\u003d\"https://www.jorgvandeven.nl/ventastic-solutions/?utm_source\u003dgoogle\u0026utm_medium\u003dgtm\u0026utm_campaign\u003dgtm_template_platform_array_rewrite\"\u003eVentastic Solutions\u003c/a\u003e\u003c/strong\u003e"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromDataLayer = require('copyFromDataLayer');
let ecommerce;
const selected = data.mapValues;
if (selected === 'auto') {
  ecommerce = copyFromDataLayer('ecommerce', 1) || {};
} else {
  ecommerce = data.manual;
}
// All UA ecommerce events
let events = ecommerce.impressions || ecommerce.productClick || ecommerce.detail || ecommerce.add || ecommerce.remove || ecommerce.checkout || ecommerce.purchase || {};
let ecommerceArray = ecommerce.items || events.products || events || [];

if (!ecommerceArray || !ecommerceArray.length) {
  return undefined;
}

let id       = ecommerceArray.map(obj => { if (obj.id)       { return obj.id; }       else { return obj.item_id; } });
let name     = ecommerceArray.map(obj => { if (obj.name)     { return obj.name; }     else { return obj.item_name; } });
let price    = ecommerceArray.map(obj => obj.price);
let brand    = ecommerceArray.map(obj => { if (obj.brand)    { return obj.brand; }    else { return obj.item_brand; } });
let quantity = ecommerceArray.map(obj => obj.quantity);
let category = ecommerceArray.map(obj => { if (obj.category) { return obj.category; } else { return obj.item_category; } });
let variant  = ecommerceArray.map(obj => { if (obj.variant)  { return obj.variant; }  else { return obj.item_variant; } });

let items;
const platform    = data.platform;
const contentType = data.contentType;
const currency    = data.currency;

if (platform === 'fb') {
  items = id.map(function (param, index) {
    return {
      'id':       id[index],
      'name':     name[index],
      'price':    price[index],
      'category': category[index],
      'quantity': quantity[index]
    };
  });
} else if (platform === 'pt') {
  items = id.map(function (param, index) {
    return {
      'product_id':       id[index],
      'product_name':     name[index],
      'product_price':    price[index],
      'product_quantity': quantity[index]
    };
  });
} else if (platform === 'tk') {
  items = id.map(function (param, index) {
    return {
      'content_type': contentType,
      'quantity':     quantity[index],
      'description':  variant[index],
      'content_id':   id[index],
      'content_name': name[index],
      'currency':     currency,
      'value':        price[index]
    };
  });
}

return items;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ecommerce"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 26-8-2022 15:44:10


