# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

	robot.hear /valor (.*)/i, (res) ->
	    ind = res.match[1]
	    todaysDate = new Date()
	    currentYear = todaysDate.getFullYear()
	    currentDay = todaysDate.getDate()
	    currentMonth = todaysDate.getMonth()+1
	    currentDate = currentDay + "-" + currentMonth + "-" + currentYear

	    res.http("https://mindicador.cl/api/#{ind}/#{currentDate}")
			.get() (err, httpRes, body) ->
		        data = JSON.parse(body)
		        valor = data.serie[0].valor
		        res.send "Valor #{ind} hoy: #{valor} pesos"


	# ELK Integration

	# Get request to check if elasticsearch integration is available.

	robot.hear /laptop/i, (res) ->
		res.http("http://127.0.0.1:9200")
			  	.header('Accept', 'application/json')
			  	.get() (err, msg, body) ->
			    	testData = JSON.parse body
			    	res.send "#{testData.number}"

	# Asks for sedentary women data.

	robot.hear /average sedentary people/i, (res) ->
	    data = JSON.stringify({
	      "query": "SELECT ROUND(AVG(edad)) AS promedio FROM persona WHERE nrovecesdeporte = 1"
	    })
	 
	    res.http("http://localhost:9200/_sql?format=json")
	      .header('Content-Type', 'application/json')
	      .post(data) (err, httpRes, body) ->
	        dataRes = JSON.parse(body)
	        valor = dataRes.rows[0]
	        res.send "Promedio: #{valor}"
	 
	# Asks for active female average data.

  	robot.hear /average active women/i, (res) ->
	    data = JSON.stringify({"query": "SELECT ROUND(AVG(edad)) AS promedio FROM persona WHERE nrovecesdeporte > 3 AND genero='Femenino'"
	    })
 
	    res.http("http://localhost:9200/_sql?format=json")
	      .header('Content-Type', 'application/json')
	      .post(data) (err, httpRes, body) ->
	        dataRes = JSON.parse(body)
	        valor = dataRes.rows[0]
	        res.send "Promedio: #{valor}"
 
	# Asks for active people data.

	robot.hear /average active people/i, (res) ->
	data = JSON.stringify({
	  "query": "SELECT ROUND(AVG(edad)) AS promedio FROM persona WHERE nrovecesdeporte > 3 AND edad > 40"
	})

	res.http("http://localhost:9200/_sql?format=json")
	  .header('Content-Type', 'application/json')
	  .post(data) (err, httpRes, body) ->
	    dataRes = JSON.parse(body)
	    valor = dataRes.rows[0]
	    res.send "Promedio: #{valor}"


	# Alterantive script for average sedentary people.
 	
 	robot.hear /average sedentary people 2/i, (res) ->
	    data = JSON.stringify({
	      	"size": 0,
	      	"aggs": {
	      	  "User_based_filter": {
	      	    "filter": {
	      	      "term": {
	      	        "nrovecesdeporte": "1"
	      	      }
	      	    },
	      	    "aggs": {
	      	      "avg_price": {
	      	        "avg": {
	      	          "field": "edad"
	      	        }
	      	      }
	      	    }
	      	  }
	      	}
	    })

	    res.http("http://localhost:9200/ejerciciofinal/_search")
	      	.header('Content-Type', 'application/json')
	      	.post(data) (err, msg, body) ->
	      		resultado = JSON.parse body
	      		res.send "#{resultado.aggregations.User_based_filter.avg_price.value}"
	        


  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
