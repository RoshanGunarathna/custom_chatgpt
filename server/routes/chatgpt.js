//IMPORTS FROM PACKAGES
const express = require('express');
const chatgptRouter = express.Router();
const { Configuration, OpenAIApi } = require("openai");

//INIT
const configuration = new Configuration({
    organization: "Org-Key",
    apiKey: "Open Ai API key",
});
const openai = new OpenAIApi(configuration);

chatgptRouter.post('/', async (req, res) => {
    try {
        const {message}= req.body;
        const response = await openai.createCompletion({
          model: "text-davinci-003",
          prompt: `
          Make and beautiful pop song using these words ${message}. 
          `,
          max_tokens: 500,
          temperature: 0.5,
        });
        res.json({
            message: response.data.choices[0].text,
        })
    } catch (error) {
        res.status(500).json({error: error.message})
    }

  });

  module.exports = chatgptRouter;