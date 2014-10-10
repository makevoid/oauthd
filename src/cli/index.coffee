exec = require('child_process').exec
ncp = require 'ncp'

scaffolding = require('../scaffolding')({ console: true })


pckg_info = require '../../package.json'

argv = require('minimist')(process.argv.slice(2))

args = argv._
options = argv


endOfInit = (name, showGrunt) ->
	info = 'Running npm install'
	command = 'cd '+ name + ' && npm install'
	if showGrunt
		info += ' and grunt.'
		command += ' && grunt'
	else
		info += '.'
	console.log info.green + ' Please wait, this might take up to a few minutes.'.yellow
	exec = require('child_process').exec
	exec command, (error, stdout, stderr) ->
		if error
			console.log "Error running command \"" + command + "\"."
			console.log error
		else
			console.log 'Done'
			r_command = 'cd ' + name + ' && oauthd start'
			console.log 'Thank you for using oauthd. Run ' + r_command.green + ' to start the instance'


displayHelp = () ->
	console.log 'Usage: oauthd <command> [arguments]'
	console.log ''
	console.log 'Available commands'
	console.log '    oauthd ' + 'init'.yellow + '\t\t\t\t\t' + 'Initializes a new oauthd instance'
	console.log '    oauthd ' + 'start'.yellow + '\t\t\t\t' + 'Starts an oauthd instance'
	console.log '    oauthd ' + 'plugins'.yellow + ' <command> [arguments]' + '\t' + 'Starts an oauthd instance'
	console.log ''
	console.log 'oauthd <command> ' + '--help'.green + ' for more information about a specific command'


options.help = options.help || options.h

# Command line parse
if options.help and args.length == 0
	displayHelp()
else if argv.version || argv.v
	console.log pckg_info.name + ' ' + pckg_info.version
else
	if args[0] == 'init'
		scaffolding.init()
			.then (name) ->
				endOfInit(name, true)
			.fail (err) ->
				console.log 'An error occured: '.red + e.message.yellow
	else if args[0] == 'start'
		require('../oauthd').init()
	else if args[0] == 'plugins'
		if options.help && args[0].lenght == 1
			require('./plugins')(args, options).help()
		args.shift()
		require('./plugins')(args, options).command()
			.then () ->
				return
			.fail (e) ->
				console.log e.message
	else
		displayHelp()


# process.exit()


# # unknown command
# else
# 	console.log cli.plugins
# 	# if not cli.argv.help?
# 	# 	if cli.argv._[0] 
# 	# 		console.log 'oauthd: ' + 'Unknown command'.red +  ' "' + cli.argv._[0].yellow + '"'
# 	# 	else
# 	show_error = true
# 	for k,v of cli.argv
# 		if v == true
# 			show_error = false
# 		if v?.length? and v.length > 0
# 			show_error = false

# 	if show_error
# 		console.log 'Missing arguments.'.red + ' Please execute "' + 'oauthd --help'.yellow + '" to get a list of commands'
# 		process.exit(1)