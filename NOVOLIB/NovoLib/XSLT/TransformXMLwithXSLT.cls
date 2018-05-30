Class NovoLib.XSLT.TransformXMLwithXSLT Extends %RegisteredObject
{

/// do ##class(User.XMLTest).Test()
ClassMethod Test()
{
    set source = ..GetXData("Source")
    set xslt = ..GetXData("XSLT")
    #dim result As %Stream.Object
    set sc = ##class(%XML.XSLT.Transformer).TransformStream(source, xslt, .result)
    
    do result.OutputToDevice()
}

ClassMethod GetXData(name) As %Stream.TmpCharacter [ CodeMode = expression ]
{
##class(%Dictionary.XDataDefinition).IDKEYOpen($classname(), name).Data
}

XData Source
{
<Message><Header><Code>HOT</Code><Date>2017-12-08 11:22:34.658</Date></Header><Body><Code>HOT</Code><Name>SIDE</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>F</Nder><TBC>21</TBC><BO>14</BO><DBOC>0</DBOC><LBC>5</LBC><AB>2</AB></Body><Body><Code>HOT</Code><Name>DARS</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>OADULT</ardge><Nder>U</Nder><TBC>20</TBC><BO>16</BO><DBOC>0</DBOC><LBC>2</LBC><AB>2</AB></Body><Body><Code>HOT</Code><Name>ENTLE</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>M</Nder><TBC>22</TBC><BO>18</BO><DBOC>0</DBOC><LBC>3</LBC><AB>1</AB></Body><Body><Code>HOT</Code><Name>ROOXED</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>OADULT</ardge><Nder>U</Nder><TBC>17</TBC><BO>7</BO><DBOC>0</DBOC><LBC/><AB>9</AB></Body><Body><Code>HOT</Code><Name>DUK</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>F</Nder><TBC>20</TBC><BO>17</BO><DBOC>0</DBOC><LBC>1</LBC><AB>2</AB></Body><Body><Code>HOT</Code><Name>DALE</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>M</Nder><TBC>18</TBC><BO>15</BO><DBOC>0</DBOC><LBC>2</LBC><AB/></Body><Body><Code>HOT</Code><Name>DAN</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>OADULT</ardge><Nder>U</Nder><TBC>16</TBC><BO>8</BO><DBOC>0</DBOC><LBC/><AB>8</AB></Body><Body><Code>HOT</Code><Name>DUN</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>U</Nder><TBC>2</TBC><BO>0</BO><DBOC>0</DBOC><LBC>1</LBC><AB>1</AB></Body><Body><Code>HOT</Code><Name>DUW</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>U</Nder><TBC>3</TBC><BO>2</BO><DBOC>0</DBOC><LBC>1</LBC><AB/></Body><Body><Code>HOT</Code><Name>DUM</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>OADULT</ardge><Nder>U</Nder><TBC>22</TBC><BO>18</BO><DBOC>0</DBOC><LBC>2</LBC><AB>2</AB></Body><Body><Code>HOT</Code><Name>DUR</Name><Type>AADULT</Type><Sec>MSec</Sec><ardge>Adult</ardge><Nder>U</Nder><TBC>16</TBC><BO>13</BO><DBOC>0</DBOC><LBC>2</LBC><AB/></Body></Message>
}

XData XSLT
{
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" indent="yes"/>
    <xsl:template match="/*[node()]">
        <xsl:text>{</xsl:text><xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates select="." mode="detect" />
  <xsl:text>&#xa;</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="*" mode="detect">
        <xsl:choose>
            <xsl:when test="name(preceding-sibling::*[1]) = name(current()) and name(following-sibling::*[1]) != name(current())">
                    <xsl:apply-templates select="." mode="obj-content" />
     <xsl:text>&#xa;</xsl:text>
                <xsl:text>]</xsl:text>
                <xsl:if test="count(following-sibling::*[name() != name(current())]) &gt; 0">, </xsl:if>
            </xsl:when>
            <xsl:when test="name(preceding-sibling::*[1]) = name(current())">
                    <xsl:apply-templates select="." mode="obj-content" />
                    <xsl:if test="name(following-sibling::*) = name(current())">, </xsl:if>
            </xsl:when>
            <xsl:when test="following-sibling::*[1][name() = name(current())]">
                <xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>" : [</xsl:text>
        <xsl:text>&#xa;</xsl:text>
                    <xsl:apply-templates select="." mode="obj-content" /><xsl:text>, </xsl:text>
     <xsl:text>&#xa;</xsl:text>
            </xsl:when>
            <xsl:when test="count(./child::*) > 0 or count(@*) > 0">
                <xsl:text>"</xsl:text><xsl:value-of select="name()"/>" : <xsl:apply-templates select="." mode="obj-content" />
                <xsl:if test="count(following-sibling::*) &gt; 0">, </xsl:if>
            </xsl:when>
            <xsl:when test="count(./child::*) = 0">
                <xsl:text>"</xsl:text><xsl:value-of select="name()"/>" : "<xsl:apply-templates select="."/><xsl:text>"</xsl:text>
                <xsl:if test="count(following-sibling::*) &gt; 0">, </xsl:if>
    <xsl:text>&#xa;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="obj-content">
     <xsl:text>&#xa;</xsl:text>
        <xsl:text>{</xsl:text>
  <xsl:text>&#xa;</xsl:text>
            <xsl:apply-templates select="@*" mode="attr" />
            <xsl:if test="count(@*) &gt; 0 and (count(child::*) &gt; 0 or text())">, </xsl:if>
            <xsl:apply-templates select="./*" mode="detect" />
            <xsl:if test="count(child::*) = 0 and text() and not(@*)">
                <xsl:text>"</xsl:text><xsl:value-of select="name()"/>" : "<xsl:value-of select="text()"/><xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="count(child::*) = 0 and text() and @*">
                <xsl:text>"text" : "</xsl:text><xsl:value-of select="text()"/><xsl:text>"</xsl:text>
            </xsl:if>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() &lt; last()">, </xsl:if>
    </xsl:template>
    <xsl:template match="@*" mode="attr">
        <xsl:text>"</xsl:text><xsl:value-of select="name()"/>" : "<xsl:value-of select="."/><xsl:text>"</xsl:text>
        <xsl:if test="position() &lt; last()">,</xsl:if>
    </xsl:template>
    <xsl:template match="node/@TEXT | text()" name="removeBreaks">
        <xsl:param name="pText" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="not(contains($pText, '&#xA;'))"><xsl:copy-of select="$pText"/></xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(substring-before($pText, '&#xD;&#xA;'), ' ')"/>
                <xsl:call-template name="removeBreaks">
                    <xsl:with-param name="pText" select="substring-after($pText, '&#xD;&#xA;')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
}

}
