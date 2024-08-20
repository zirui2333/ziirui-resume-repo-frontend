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
    // const data_event = JSON.stringify(data.event)
    counter.innerHTML = `${data.count}`;
    // console.log(data)
    // console.log(data.event)
  } catch (error) {
    // console.log(error)
    counter.innerHTML = `43`;
  }
}


async function update_views_2(){
  const WebSocket = require('ws');
  const socket = new WebSocket("wss://ufjjbvto1b.execute-api.us-east-1.amazonaws.com/production/");
  // Connection opened
  socket.addEventListener("open", (event) => {
    socket.send("Hello Server!");
  });

  // Listen for messages
  socket.addEventListener("message", (event) => {
    console.log("Message from server ", event.data);
  });
}
update_views_2();
