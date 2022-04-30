const express = require('express')
const mongodb = require('mongodb')
const filesystem = require("fs");

const uri = filesystem.readFileSync("server.txt").toString();
const client = new mongodb.MongoClient(uri, {
    useNewUrlParser: true, 
    useUnifiedTopology: true
}); 

const app = express()
const port = 3000
app.use(express.json())

let changeStream;
async function run() {
    await client.connect();

    const mafDB = client.db("meetafriend");
    const locationsDB = mafDB.collection("locations");

    changeStream = locationsDB.watch();
    changeStream.on('change', next => {
        console.log(`Received a change to the collection ${next}`);
    });
}

async function insertNewLocation(newLocation) {
    const mafDB = client.db("meetafriend");
    const locationsDB = mafDB.collection("locations");

    await locationsDB.insertOne(newLocation);
}


app.get('/locations', (req, res) => {
    res.status(200).send({
        hello: "world"
    })
})

app.post('/locations', (req, res) => {
    insertNewLocation(req.body);
    res.status(201).send();
})

app.listen(port, () => {
    console.log(`Meet a friend location API listening on port ${port}`)
})

run().catch(console.error);