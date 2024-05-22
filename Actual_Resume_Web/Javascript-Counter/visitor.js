const counter = document.querySelector(".counter_views")

async function update_views(){
  try{
    const response = await fetch("https://evjwodhvurdul6u545smt3yfay0syutw.lambda-url.us-east-1.on.aws/");
    const data = await response.json();
    counter.innerHTML = `views:  ${data}`;
  } catch(error){
    counter.innerHTML = `The fetch function has issue in javascript` + error;
  }
}

update_views();

