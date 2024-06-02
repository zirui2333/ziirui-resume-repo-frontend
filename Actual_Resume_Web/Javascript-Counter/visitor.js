const counter = document.querySelector(".counter_views");

async function update_views() {
  try {
    const response = await fetch("https://7m6lwapwwvhhjwvhnxwntpi2ba0nctzb.lambda-url.us-east-1.on.aws/",{
        method: 'POST',  // Set the method to POST
        headers: {
            'Content-Type': 'application/json/update_counter'
        },
        body: JSON.stringify({})
    }
  );

    const data = await response.json();
    counter.innerHTML = `${data.count}`;
    // console.log(data)
    // console.log(data.count)
  } catch (error) {
    // console.log(error)
    counter.innerHTML = "43";
  }
}

update_views();

