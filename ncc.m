clear;
% ��֧��2ά�Ҷ�ͼ��
sub_img=imread('sub_img1.jpg'); %��ȡ��Ҫƥ�����Ԫ��
img=imread('img12.jpg'); %ƥ��ͼ��
[m0,n0]=size(sub_img); %��ȡͼ���С����ά�Ҷ�ͼ
[m,n]=size(img);
hm = m-m0+1;
wm = n-n0+1;
vec_sub = double( sub_img(:) );
norm_sub = norm( vec_sub ); %2-��������������
match = -inf; % ������

%�ҵ�������λ��
figure; % ����ͼ��
hold on
subplot(1,2,1);
imshow(sub_img);
title('subimg');
hold off

for i=1:hm
    for j=1:wm
        for k0 = m0:fix(m0/10):m-i % ���ʵ���С����10�Լӿ�ʶ���ٶȣ�����>=4
            k1 = fix(n0*k0/m0); % ȡ�����������Ŵ�
            if k1>n-j
                break;
            end
            subMatr=img(i:i+k0-1,j:j+k1-1);
            for i0 = 1:k0-m0
                [m1,n1] = size(subMatr);
                r0 = randi(m1);
                subMatr(r0,:) = []; % ɾ��r0��
            end
            for j0 = 1:k1-n0
                [m1,n1] = size(subMatr);
                r1 = randi(n1);
                subMatr(:,r1) = []; % ɾ��r1��
            end
            
            vec=double( subMatr(:) );
            tmp = vec'*vec_sub / (norm(vec)*norm_sub+eps); % ����ƥ���
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
                plot(y0,x0,'*'); % ���Ͻ�
                w=k1;
                h=k0;
                plot([y0,y0+w-1],[x0,x0],'-or'); %��
                plot([y0,y0+w-1],[x0+h-1,x0+h-1],'-or');%��
                plot([y0,y0],[x0,x0+h-1],'-or');%��
                plot([y0+w-1,y0+w-1],[x0,x0+h-1],'-or');%��
                hold off
            end
            if match > 0.99 % ƥ��ȴﵽ0.99����Ϊ���ҵ�ƥ�����
                return;
            end
        end
    end
end
