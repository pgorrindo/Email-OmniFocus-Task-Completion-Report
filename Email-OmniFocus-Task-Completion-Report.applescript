--==============================
-- Script name: Email OmniFocus Task Completion Report
-- Version 1.2
-- Written By: Phil Gorrindo <pgorrindo.github@gorrindo.com> and http://phil.gorrindo.com
-- Description: This script retrieves a list of OmniFocus tasks completed yesterday or today. It then sends an email report.
-- Version History:
-- 		1.0 - Initial release
--		1.1 - fixed errors on unescaped angle brackets and quotes, and removed context/project title code to speed up script
--		1.2 - added switch for sending email via mail.app or command-line, since command-line doesn't work with some ISPs
-- Based on the following original scripts: 
--		http://www.tuaw.com/2013/04/15/applescripting-omnifocus-send-completed-task-report-to-evernot/
--		http://veritrope.com/code/write-todays-completed-tasks-in-omnifocus-to-a-text-file/

--==============================

property toAddress : "to@example.com"
property fromAddress : "from@example.com"
property theReportScope : "Yesterday"
--property theReportScope : "Today"

-- send the email via Mail.app or via command-line. Command-line won't always work, if an ISP blocks this
-- possible options: "mail.app" | "cli"
property emailMethod : "mail.app"


set theMessage to my do_OmniFocus()

my send_email(theMessage)


on do_OmniFocus()
	set theStartDate to current date
	set hours of theStartDate to 0
	set minutes of theStartDate to 0
	set seconds of theStartDate to 0
	set theEndDate to theStartDate + (23 * hours) + (59 * minutes) + 59
	
	if theReportScope = "Today" then
		--then do nothing
	else if theReportScope = "Yesterday" then
		set theStartDate to theStartDate - 1 * days
		set theEndDate to theEndDate - 1 * days
	end if
	
	set theMessage to "<html><body><h2>OmniFocus Tasks Completed on " & (date string of theStartDate) & "</h2><br>"
	
	tell application "OmniFocus"
		activate
		tell default document
			set refDoneTasks to a reference to (flattened tasks where (completion date ³ theStartDate) and (completion date ² theEndDate))
			set numberTasks to count of refDoneTasks
			
			set theMessage to theMessage & "<h3>Number of tasks completed: " & numberTasks & "</h3><br><hr>"
			set theMessage to theMessage & "<ul>"
			
			set {lstName} to {name} of refDoneTasks
			repeat with iTask from 1 to count of lstName
				set {strName} to {item iTask of lstName}
				set strName to my remove_quotes(strName)
				
				set theMessage to theMessage & "<li>" & strName
				set theMessage to theMessage & "</li><br>"
			end repeat
		end tell
	end tell
	
	set theMessage to theMessage & "</ul><hr></body></html>"
end do_OmniFocus


on send_email(theMessage)
	set theTimeStamp to (do shell script "date '+%Y-%m-%d %H:%M:%S'")
	set theSubject to "OmniFocus Completed Task Report (" & theTimeStamp & ")"
	
	if emailMethod is equal to "mail.app" then
		tell application "Mail"
			set theNewMessage to make new outgoing message with properties {subject:theSubject, html content:theMessage}
			set sender of theNewMessage to fromAddress
			tell theNewMessage
				make new to recipient at end of to recipients with properties {address:toAddress}
				send
			end tell
		end tell
		
	else if emailMethod is equal to "cli" then
		do shell script "echo " & quote & theMessage & quote & " | mail -s \"$(echo \"" & theSubject & "\nContent-Type: text/html\")\" " & toAddress & " -f " & fromAddress
	end if
end send_email


on remove_quotes(strName)
	set astid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to quote
	set strName to text items of strName
	set AppleScript's text item delimiters to ""
	set strName to strName as text
	set AppleScript's text item delimiters to astid
	return strName
end remove_quotes
