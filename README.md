# Platform Array Rewrite

This Google Tag Manager variable template rewrites the e-commerce `items` array from a GA4 or Universal Analytics (EEC) dataLayer into the format required by a specific marketing platform. Instead of manually remapping each key per tag, you configure the template once and it returns a ready-to-use array for the platform of your choice.

This template supports **Facebook**, **Pinterest**, and **TikTok**. For example, for a Facebook `Purchase` event, the template returns an array like `[{"id": "T12345", "name": "T-Shirt Blue", "price": 29.99, "category": "Apparel", "quantity": 1}]` — matching the `contents` parameter Facebook expects.

It is compatible with both GA4 (`ecommerce.items`) and Universal Analytics Enhanced Ecommerce (`ecommerce.detail.products`, `ecommerce.add.products`, etc.), and can read directly from the dataLayer or accept a manually specified variable.

## How to Use

1. **Upload the Template**: Upload this GTM template to your GTM container.
2. **Create a Variable**: Create a new variable using this template.
3. **Select a Data Source**: Choose `Automatically read from dataLayer` to have the template read the `ecommerce` object directly, or select `Select e-commerce variable` and point it to a variable that holds your products or items array (e.g. `eventModel.items`).
4. **Choose Your Platform**: Select the platform you want to rewrite the array for — Facebook, Pinterest, or TikTok. For TikTok, also configure the `content_type` (`product` or `product_group`) and `currency`.
5. **Add the Variable to Your Tags**: Use the variable in the appropriate parameter of your platform tag. For example, add it as the `contents` parameter in a Facebook tag, or as `line_items` in a Pinterest tag.

## Output Format per Platform

**Facebook**
```json
[{ "id": "T12345", "name": "T-Shirt Blue", "price": 29.99, "category": "Apparel", "quantity": 1 }]
```

**Pinterest**
```json
[{ "product_id": "T12345", "product_name": "T-Shirt Blue", "product_price": 29.99, "product_quantity": 1 }]
```

**TikTok**
```json
[{ "content_type": "product", "content_id": "T12345", "content_name": "T-Shirt Blue", "description": "Blue", "price": 29.99, "quantity": 1, "currency": "EUR" }]
```

## Creator

The Tag template was created by [Jorg van de Ven](https://www.linkedin.com/in/jorgvandeven/)
