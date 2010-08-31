def mk_link(url, txt, htmlclass='')
	if htmlclass == '' then
		"<a href=\"#{$app_root}/#{url}\">#{txt}</a>"
	else
		"<a href=\"#{$app_root}/#{url}\" class=\"#{htmlclass}\">#{txt}</a>"
	end
end

def mk_abs_link(url,txt, htmlclass='')
	if htmlclass == '' then
		"<a href=\"/#{url}\">#{txt}</a>"
	else
		"<a href=\"/#{url}\" class=\"#{htmlclass}\">#{txt}</a>"
	end
end