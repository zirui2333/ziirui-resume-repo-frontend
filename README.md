# About the Project

## Foreword

Welcoming everyone to access my website: www.ziirui-resume-website.com

Here is a [Comprehensive Tutorial](https://www.ziirui-resume-website.com/posts/tech/cloud_website/) I made for creating this cloud projects

## Description

This is a Full stack serverless cloud project on AWS for hosting a personal domain website with DevOps skills

It's also my first cloud project at cloud resume challenge by using AWS. What is Cloud Resume Challenge? - The [Cloud Resume Challenge](https://cloudresumechallenge.dev/) is a multiple-step resume project which helps build and demonstrate skills fundamental to pursuing a career in Cloud. The project was published by Zirui Zheng.

**Features:**

- Create personal resume website frame using **HTML & CSS**
- Deploy the webiste using **AWS** S3 and Cloudfront distribution
- Connect the distribution by CloudFare custom domain name in the frontend
- Implement **Javascript** to create a visitor counter displays how many people have accessed the site.
- Retrieve and update visitor counter value in DynamoDB Table
- Interacting database with **Python** code in Lambda Function, trigger by AWS Function URL
- **Infrastructure as Code** all the AWS resouces mentioned above by **terraform**
- Create **CI/CD pipeline** for both frontend and backend on **GitHub Action**

## Graph

![Cloud Diagram.jpg](https://github.com/zirui2333/ziirui-resume-repo-frontend/blob/main/Readme_Item/Cloud-resume-diagram.jpg?raw=true)

## Kindly Note

Directly clone my repository will not do anything because most of my steps are done in AWS and Terraform. You can refer to my [website guildline](https://www.ziirui-resume-website.com/posts/tech/cloud_website/) to start.
<br>

# Hugo Thing

## 1. Installation

If you're interesting at using my webiste style. Please checkout [Papermod](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation#getting-started-) for setting up both Hugo and Papermod theme.
You can also see **reference** section to get detailed implementation of cool features!

## 2. Reference

There are many personal information in the template that need to be configured by yourself. Please be patient to modify it. You can refer to the blogger's website building tutorial: [中文](https://www.sulvblog.cn/posts/blog/) | [En](https://kyxie.github.io/en/blog/tech/papermod/)

## 3. Hugo blog exchange group

🎉🎉 787018782 🎉🎉

## 4. Possible problems

1. Some users will deploy to GitHub and may encounter cross system problems, such as the prompt `lf will be replaced by CRLF in *******`, if so, enter the command: `git config core.autocrlf false`, which solves the problem of automatic conversion of line breaks。

2. For any PaperMod specific issues, feel free to visit [PaperMod](https://github.com/adityatelange/hugo-PaperMod?tab=readme-ov-file#faqs--how-tos-guide-)
