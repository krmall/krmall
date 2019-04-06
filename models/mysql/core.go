package mysql

import (
	"github.com/krmall/krmall/models/model"
	"net/http"
)

// GetMainPage get main page data
func (r *mysqlRepository) GetMainPage() (interface{}, error) {
	data := &model.MainPage{Url: "/index/index"}
	return &model.Result{ErrorNo: http.StatusOK, Data: data}, nil
}
