module ApplicationHelper
    def active(path)
        current_page?(path) ? 'active' : ''
    end

    def path_start_with_active(prefix)
        request.fullpath.start_with?(prefix) ? 'active' : ''
    end
end
