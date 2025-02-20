function [ fig ] = plot_results( psi, loc_est, room)
%PLOT_RESULTS Plots location estimation results
    if size(psi, 3)>1
        iterations = size(psi, 1);
    else
        iterations=1;
    end

    scr_size = get(0,'ScreenSize');
    fig_size = [2*scr_size(3)/3 scr_size(4)/2];  % width x height
    fig_xpos = ceil((scr_size(3)-fig_size(1))/2); % center the figure on the screen horizontally
    fig_ypos = ceil((scr_size(4)-fig_size(2))/2); % center the figure on the screen vertically
    fig = figure('Name','Location Estimate Result',...
                  'NumberTitle','off',...
                  'Color','white',...
                  'Position', [fig_xpos fig_ypos fig_size(1) fig_size(2)]);%,...
                  %'Visible','off');  TODO: Comment this back in for trial runs!

    if iterations>1  % plot entire em-step history
        for i=1:iterations
            subplot_tight(2,iterations,i)
            imagesc(room.grid_x,room.grid_y,squeeze(psi(i,:,:)))
            set(gca,'Ydir','Normal')
            set(gca, 'box', 'off')
            hold on

            plot(room.R(:, 1), room.R(:, 2),'x','MarkerSize', 12, 'Linewidth',2,'Color','g');
            plot(room.S(:, 1), room.S(:, 2),'x','MarkerSize', 16, 'Linewidth',2,'Color','w');
            plot(loc_est(:, 1), loc_est(:, 2),'x','MarkerSize', 16, 'Linewidth',2,'Color','r');

            axis([0,room.dimensions(1),0,room.dimensions(2)]);
            subplot_tight(2,iterations,i+iterations)
            fprintf('grid_x = %dx%d, grid_y = %dx%d, psi = %dx%d', size(room.grid_x, 1), size(room.grid_x, 2), size(room.grid_y, 1), size(room.grid_y, 2), size(psi, 2), size(psi, 3))
            surf(room.grid_x,room.grid_y,squeeze(psi(i,:,:)))
            view([-10 35]);
            shading interp
        end
    else            % plot only final result
        subplot_tight(1,2,1);
        imagesc(room.grid_x,room.grid_y,psi)
        set(gca,'Ydir','Normal')
        set(gca, 'box', 'off')
        hold on

        plot(room.R(:, 1), room.R(:, 2),'x','MarkerSize', 12, 'Linewidth',2,'Color','g');
        plot(room.S(:, 1), room.S(:, 2),'x','MarkerSize', 16, 'Linewidth',2,'Color','w');
        plot(loc_est(:, 1), loc_est(:, 2),'x','MarkerSize', 16, 'Linewidth',2,'Color','r');
        axis([0,room.dimensions(1),0,room.dimensions(2)]);

        subplot_tight(1,2,2);
        surf(room.grid_x,room.grid_y,psi)
        view([-65 25]);
        shading interp
    end
end
