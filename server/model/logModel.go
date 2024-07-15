package model

import "time"

type Log struct {
	ID        int       `json:"id"`
	Timestamp time.Time `json:"timestamp"`
	Method    string    `json:"method"`
	Path      string    `json:"path"`
	ClientIP  string    `json:"client_ip"`
	StatusCode int      `json:"status_code"`
	Duration  time.Duration `json:"duration"`
	ErrorMsg  string    `json:"error_msg,omitempty"`
}
