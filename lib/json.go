package lib

import (
	"net/http"

	"git.rrdc.de/lib/lg"
	"github.com/gin-gonic/gin"
)

// Jsonify makes a json for the HTTP Server response
func Jsonify(c *gin.Context, rows interface{}, count int, err error) {
	var success = true
	if err != nil {
		success = false
		count = 0
		lg.PrintErrWithStack(err)
	}
	result := gin.H{
		"success": success,
		"result":  rows,
		"count":   count,
	}
	c.JSON(http.StatusOK, result)
}
