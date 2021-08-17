s3 Static Web Hosting
---
For static website hosting, there are 3 things you need to configure
1. Enable static website hosting feature in `Properties` tab, at the end you will see `Static web hosting`, click `edit` and select `Enable`, select `Hosting type` as `Host a static website` enter `index document` as `index.html`
2. Update Bucket Policy (Permissions tab)
3. Uncheck `Block all public access` (Permissions tab)

Bucket Policy is available in policy.json (ensure to change the bucket name arn)

Once the bucket creation completed, add index.html file to the bucket

`aws s3 cp index.html s3://my-bucket-name`

Ensure to replace my-bucket-name and region in below (us-east-1) while accessing the url in browser

http://my-bucket-name.s3-website-region.amazonaws.com

If you got access denied error, it is probably related to block public access in permission tab.