## Serverless cloud project on AWS for hosting a personal domain website

Welcoming everyone to access my website: www.ziirui-resume-website.com

## Short Explaination of what my project does

AWS Cloud Resume Challenge

This is my first cloud project at cloud resume challenge by using AWS. What is Cloud Resume Challenge? - The Cloud Resume Challenge is a multiple-step resume project which helps build and demonstrate skills fundamental to pursuing a career in Cloud. The project was published by Zirui Zheng.

**Features:**

> - Create personal resume website frame using HTML & CSS
> - Deploy the webiste using AWS S3 and Cloudfront distribution
> - Connect the distribution by CloudFare custom domain name in the frontend
> - A visitor counter displays how many people have accessed the site supported by Javascript
> - Retrieve and update visitor counter value in DynamoDB Table
> - Interacting database with python code in lambda function, trigger by AWS Function URL
> - Infrastructure as Code all the AWS resouces mentioned above by terraform
> - Create CI/CD for frontend and backend on github

## 1. Git clone pull code

① Use `git clone` to clone the repository to your desktop. At this time, the Hugo papermod directory will be generated.

② Go to the root Hugo directory and enter `git submodule update --init` to pull the submodule under themes / Hugo papermod / and put the official theme inside

## 2. Startup interface

③ Return the directory to sulv Hugo papermod, enter `hugo server -d` in the terminal, and enter: localhost:1313 in the browser to see the ready-made blog template.

## 3. Modify information

There are many personal information in the template that need to be configured by yourself. Please be patient to modify it. You can refer to the blogger's website building tutorial:[中文](https://www.sulvblog.cn/posts/blog/) | [En] ( https://kyxie.github.io/en/blog/tech/papermod/ )

## 4. Hugo blog exchange group

🎉🎉 787018782 🎉🎉

## 5. How to use shortcodes

`bilibili: {{< bilibili BV1Fh411e7ZH(填 bvid) >}}`

`youtube: {{< youtube w7Ft2ymGmfc >}}`

`ppt: {{< ppt src="网址" >}}`

`douban: {{< douban src="网址" >}}`

```
#Intra article link card
#To add md at the end, you can only fill in the relative path, as shown below
{{< innerlink src="posts/tech/mysql_1.md" >}}
```

## 5. Possible problems

1. Some users will deploy to GitHub and may encounter cross system problems, such as the prompt `lf will be replaced by CRLF in *******`, if so, enter the command: `git config core.autocrlf false`, which solves the problem of automatic conversion of line breaks。

2. For any PaperMod specific issues, feel free to visit [PaperMod] ( https://github.com/adityatelange/hugo-PaperMod?tab=readme-ov-file#faqs--how-tos-guide- )

## Graph

![Cloud Diagram.jpg](https://github.com/zirui2333/ziirui-resume-repo-frontend/blob/main/Readme_Item/Cloud-resume-diagram.jpg?raw=true)
