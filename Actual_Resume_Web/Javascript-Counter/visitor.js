const counter = document.querySelector(".counter_views")

async function update_views(){
  try{
    const response = await fetch("https://evjwodhvurdul6u545smt3yfay0syutw.lambda-url.us-east-1.on.aws/");
    const data = await response.json();
    const body = JSON.parse(data.body)
    counter.innerHTML = `views:  ${body.count}`;
  } catch(error){
    counter.innerHTML = error;
    console.log(`fail`)
  }
}

update_views();

