<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml"/>
   <xsl:template match="/">
     <html>
		##header_css_image##        
			
						Dear 
						##partner_first_name## ##partner_last_name##<br/><br/>
						CONGRATULATIONS!  <br/><br/>
						
						You have earned ##partner_reward## Points for participating in the ##program_name## 
						GoalQuest Program.<br/><br/>
						
						You were selected as a partner of ##first_name## ##last_name##  in the ##program_name##.<br/><br/>
						
						<xsl:if test="/StrongMail/GOAL_LEVEL != ''"> 
							They selected ##goal_level##  that had an achievement requirement of ##goal_level_amount##  which equals  ##total_goal_value##.<br/><br/>
						</xsl:if>
						
						The final results reported to us show that they have achieved ##actual_results##  which is ##percent_to_goal##  % of their personal goal!! Your reward will be ##partner_reward## Points.<br/><br/>
						
						To spend your points or for more information visit the  ##program_name##
						 			<xsl:element name="a">
										<xsl:attribute name="href">
											<xsl:value-of select="/StrongMail/SITE_LINK"/>
										</xsl:attribute>
										website				
									</xsl:element>			
						  , and click on Shop menu.<br/><br/>
						
						
						Thank you for helping to make the ##program_name##  a success!<br/><br/>
						
						Sincerely,<br/><br/>
						The  ##program_name##  GoalQuest Team<br/><br/>
						<br/><br/>
      ##footer1## 

  </xsl:template>
</xsl:stylesheet>


