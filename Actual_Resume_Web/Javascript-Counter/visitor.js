const counter = document.querySelector(".counter_views")

async function update_views(){
  try{
    const response = await fetch("https://7m6lwapwwvhhjwvhnxwntpi2ba0nctzb.lambda-url.us-east-1.on.aws/");
    const data = await response.json();
    const body = JSON.parse(data.body)
    counter.innerHTML = `${body.count}`;
  } catch(error){
    counter.innerHTML = `43`
  }
}

update_views();

