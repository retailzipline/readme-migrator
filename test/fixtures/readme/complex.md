---
title: "Inventory Adjustments"
excerpt: ""
---
* Inventory adjustments are used anytime a one off product needs to be added or removed from your store inventory. Do not use inventory adjustments for Replenishments or purchases, those use a different method.
* You may need to make inventory adjustments if items arrive with damage, items are lost or stolen, or when products are used for display merchandising and at events. Adjustments are also made to add in products from un-opened sellable returns and in the event that a customer switches from in-store fulfillment to parcel or IHSD.
[block:api-header]
{
  "title": "Inventory Adjustment Procedure"
}
[/block]
  * Use the [Inventory adjustment form](https://docs.google.com/forms/d/1e8Bq_7A6FiQSk3xdXhhYOg8axvy0ojiDhICjib9kzv4/viewform?edit_requested=true) whenever inventory will need to be adjusted out from your stock.
  * Please use Additional Information to add any more necessary detail (e.g if it was a promotional giveaway enter the promo code in this space, whether the item was damaged in route to the store or at the store, etc.)
  * Branch Plant is now a drop-down menu. Please scroll through to find your branch plant.
  * On the Form there are 5 options for entering SKU's needing adjusted. There are also 5 options for quantities. Please enter a SKU and then the corresponding quantity below it (if the quantity is decreasing please enter a negative number. See screenshot below for example of SKU and quantity correlation.
[block:image]
{
  "images": [
    {
      "image": [
        "https://files.readme.io/05f0dd1-unnamed.png",
        "unnamed.png",
        514,
        384,
        "#f2f3f7"
      ]
    }
  ]
}
[/block]
  * If you have an adjustment that contains more than 5 SKU's you can either submit more than one form, or use the option of a *file upload*. You will see at the end of the Form an option to attach the file.
  * If you need a SKU to description reference you can use the link to the template to verify your SKU.
[block:api-header]
{
  "title": "Common Scenarios"
}
[/block]

[block:callout]
{
  "type": "info",
  "title": "Customer switches from In-store inventory to parcel or IHSD",
  "body": "1. Slack retail-cx to add a $0 replacement item to the order in solidus. Ensure new delivery address is provided.\n2. To add item back to your stock, use the adjustment form.\n\nYou Do **Not** need to slack benko-box to add the inventory back to your store"
}
[/block]

[block:callout]
{
  "type": "info",
  "title": "Customer switches from parcel/IHSD to In-Store Fulfillment",
  "body": "1. Slack retail-cx to add the $0 replacement item in solidus. Then, the cxer will Return to Sender the parcel/IHSD item to prevent it from being delivered\n2. Slack benko-box to ensure the replacement item is properly attributed to your store inventory. The CXer will typically post on your behalf but you should double check. \n\n*If this is not attributed to your store inventory, your counts will be inaccurate from what you see on your POS*"
}
[/block]

[block:api-header]
{}
[/block]
