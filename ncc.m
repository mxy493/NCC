clear;
% 仅支持2维灰度图像
sub_img=imread('sub_img1.jpg'); %截取的要匹配的子元素
img=imread('img12.jpg'); %匹配图像
[m0,n0]=size(sub_img); %获取图像大小，二维灰度图
[m,n]=size(img);
hm = m-m0+1;
wm = n-n0+1;
vec_sub = double( sub_img(:) );
norm_sub = norm( vec_sub ); %2-范数，向量长度
match = -inf; % 负无穷

%找到最大相关位置
figure; % 创建图窗
hold on
subplot(1,2,1);
imshow(sub_img);
title('subimg');
hold off

for i=1:hm
    for j=1:wm
        for k0 = m0:fix(m0/10):m-i % 可适当调小参数10以加快识别速度，建议>=4
            k1 = fix(n0*k0/m0); % 取整，按比例放大
            if k1>n-j
                break;
            end
            subMatr=img(i:i+k0-1,j:j+k1-1);
            for i0 = 1:k0-m0
                [m1,n1] = size(subMatr);
                r0 = randi(m1);
                subMatr(r0,:) = []; % 删除r0行
            end
            for j0 = 1:k1-n0
                [m1,n1] = size(subMatr);
                r1 = randi(n1);
                subMatr(:,r1) = []; % 删除r1列
            end
            
            vec=double( subMatr(:) );
            tmp = vec'*vec_sub / (norm(vec)*norm_sub+eps); % 计算匹配度
            if tmp > match
                match = tmp;
                disp(match);
                
                subplot(1,2,2);
                imshow(img);
                title('img');
                x0 = i;
                y0 = j;
                % fprintf('(x,y)=%d,%d\n',x0,y0);
                hold on
                plot(y0,x0,'*'); % 左上角
                w=k1;
                h=k0;
                plot([y0,y0+w-1],[x0,x0],'-or'); %上
                plot([y0,y0+w-1],[x0+h-1,x0+h-1],'-or');%下
                plot([y0,y0],[x0,x0+h-1],'-or');%左
                plot([y0+w-1,y0+w-1],[x0,x0+h-1],'-or');%右
                hold off
            end
            if match > 0.99 % 匹配度达到0.99则视为已找到匹配对象
                return;
            end
        end
    end
end
