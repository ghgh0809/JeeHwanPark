function [gap, slope] = GapDefine2(obj_boundary, centroid)
% Define vertical and horizontal gap g_x, g_y
% The function returns following objects:
% 1. gap = [g_x, g_y]
% 2. slope of g_x
% 
% * Returns shortest g_x, and g_y based on g_x
% 

%% Global declaration:
obj_boundary_size= size(obj_boundary);
g_x = inf;
g_y = inf;
polyin = polyshape(obj_boundary(:,1), obj_boundary(:,2));
poly_size = size(polyin.Vertices(:,1));
safety_gap = 1;
figure(1)
hold on;

%% Compute g_x:
for i=1:obj_boundary_size(1)
    points = [obj_boundary(i,1),obj_boundary(i,2) ; centroid(1),centroid(2)];
    d = pdist(points,'euclidean');
    if d < g_x
        g_x = d;
        % shortest point from the centroid:
        min_x_x = obj_boundary(i,1);
        min_x_y = obj_boundary(i,2);
        
        % slope between shortest to the centroid:
        slope_g_x = (min_x_y - centroid(2)) / (min_x_x - centroid(1));
        if (abs(slope_g_x) > 100)
            slope_g_x = inf;
        elseif(abs(slope_g_x) < 0.01)
            slope_g_x = 0;
        end
    end
end

%% Compute g_y:
% for i=1:(poly_size(1)+100)
%     if i > poly_size(1)
%         i = i - poly_size(1);
%     end
%     p1 = [polyin.Vertices(i,1), polyin.Vertices(i,2)];  % point 1
%     for j=(i+1):(poly_size(1)+100)
%         if j > poly_size
%             j = j - poly_size(1);
%         end
%         p2 = [polyin.Vertices(j,1),polyin.Vertices(j,2)];  % point 2
%         % measures the distance between p1 and p2:
%         d = round(pdist([p1; p2],'euclidean'));
%         if d >= round(g_x)
%             % measures the shortest distance between the line and the point
%             distance = point_to_line_distance([centroid(1), centroid(2)], p1, p2);
%             lineseg = [p1;p2];
%             [in,out] = intersect(polyin,lineseg);
%             check = size(out);
%             %plot([p1(1),p2(1)] , [p1(2),p2(2)],'-k');
%             slope_g_y = (p2(2)-p1(2)) / (p2(1)-p1(1));
%             if (slope_g_y >= slope_g_x - 0.2) && (slope_g_y <= slope_g_x + 0.2)
%                 if check(1) == 0
%                     if distance < g_y
%                         g_y = distance;
%                         min_g_y_p1 = p1;
%                         min_g_y_p2 = p2;
%                     end
%                 end
%             end
%             break
%         end
%     end
% end
% for i=poly_size:1
%     p1 = [polyin.Vertices(i,1), polyin.Vertices(i,2)];
%     for j=(i-1):1
%         p2 = [polyin.Vertices(j,1),polyin.Vertices(j,2)];
%         d = round(pdist([p1; p2],'euclidean'));
%         if d >= round(g_x)
%             distance = point_to_line_distance([centroid(1), centroid(2)], p1, p2);
%             lineseg = [p1;p2];
%             [in,out] = intersect(polyin,lineseg);
%             check = size(out);
%             %plot([p1(1),p2(1)] , [p1(2),p2(2)],'-k');
%             slope_g_y = (p2(2)-p1(2)) / (p2(1)-p1(1));
%             if (slope_g_y >= slope_g_x - 0.2) && (slope_g_y <= slope_g_x + 0.2)
%                 if check(1) == 0
%                     if distance < g_y
%                         g_y = distance;
%                         min_g_y_p1 = p1;
%                         min_g_y_p2 = p2;
%                     end
%                 end
%             end
%             break
%         end
%     end
% end

%% Compute g_y (precise but long):
for i=1:(obj_boundary_size(1)+round(obj_boundary_size(1)*0.2))
    if i > obj_boundary_size(1)
        i = i - obj_boundary_size(1);
    end
    p1 = [obj_boundary(i,1), obj_boundary(i,2)];
    for j=(i+1):(obj_boundary_size(1)+round(obj_boundary_size(1)*0.2))
        if j > obj_boundary_size
            j = j - obj_boundary_size(1);
        end
        p2 = [obj_boundary(j,1),obj_boundary(j,2)];
        d = round(pdist([p1; p2],'euclidean'));
        if d >= round(g_x)
            distance = point_to_line_distance([centroid(1), centroid(2)], p1, p2);
            lineseg = [p1;p2];
            [in,out] = intersect(polyin,lineseg);
            check = size(out);
            % plot([p1(1),p2(1)] , [p1(2),p2(2)],'-k');
            slope_g_y = (p2(2)-p1(2)) / (p2(1)-p1(1));
            if (slope_g_y >= slope_g_x - 0.2) && (slope_g_y <= slope_g_x + 0.2)
                if check(1) == 0
                    if distance < g_y
                        g_y = distance;
                        min_g_y_p1 = p1;
                        min_g_y_p2 = p2;
                    end
                end
            end
            break
        end
    end
end
for i=1:(obj_boundary_size(1)+round(obj_boundary_size(1)*0.2))
    if i > obj_boundary_size(1)
        i = i - obj_boundary_size(1);
    end
    p1 = [obj_boundary(i,1), obj_boundary(i,2)];
    for j=(obj_boundary_size(1)-i):0-round(obj_boundary_size(1)*0.2)
        if j < 0
            j = obj_boundary_size(1) + j;
        end
        p2 = [obj_boundary(j,1),obj_boundary(j,2)];
        d = round(pdist([p1; p2],'euclidean'));
        if d >= round(g_x)
            distance = point_to_line_distance([centroid(1), centroid(2)], p1, p2);
            lineseg = [p1;p2];
            [in,out] = intersect(polyin,lineseg);
            check = size(out);
            % plot([p1(1),p2(1)] , [p1(2),p2(2)],'-k');
            slope_g_y = (p2(2)-p1(2)) / (p2(1)-p1(1));
            if (slope_g_y >= slope_g_x - 0.2) && (slope_g_y <= slope_g_x + 0.2)
                if check(1) == 0
                    if distance < g_y
                        g_y = distance;
                        min_g_y_p1 = p1;
                        min_g_y_p2 = p2;
                    end
                end
            end
            break
        end
    end
end

%% Final return:
gap = [g_x-safety_gap, g_y-safety_gap];
slope = slope_g_x;

%% Object plot:
% plot(obj_boundary(:,1), obj_boundary(:,2));
% plot(centroid(1), centroid(2),'rx','Linewidth',2, 'markersize',13);
plot(min_x_x, min_x_y,'ko','Linewidth',2, 'markersize',5);
% plot([min_g_y_p1(1),min_g_y_p2(1)] , [min_g_y_p1(2),min_g_y_p2(2)],'-k');
% viscircles([centroid(1), centroid(2)],gap(1));
% xlim([0 600]); ylim([0 600]);
end
