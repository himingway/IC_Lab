from PIL import Image
import os, json

def color_format(mode, color):
	if mode not in ['RGB']:
		show_error('This module just supports RGB images, check your images !')
	res = ''
	for c in color:
		tmp = bin(c)[2:]
		for i in range(10 - len(bin(c))):
			tmp = '0' + tmp
		res += tmp
	return res

def create_dat(im):
	data_src = im.getdata()
	xsize, ysize = im.size
	data_res = ''
	for color in data_src:
		data_res += color_format(im.mode, color) + '\n'
	return data_res[:-1]

if __name__ == '__main__':
	FileAll = []
	FileFormat = ['.jpg', '.bmp']
	for root, dirs, files in os.walk('./images'):
		for f in files:
			name, ex = os.path.splitext(f)
			if ex in FileFormat:
				FileAll.append((root+'/', name, ex))
	dat_index = ''
	for root, name, ex in FileAll:
		im_src = Image.open(root+name+ex)
		xsize, ysize = im_src.size
		dat_res = open('../sim/%s.dat' %name, 'w')
		dat_res.write('%d\n%d\n' %(xsize,ysize))
		dat_res.write(create_dat(im_src))
		dat_index += name + '\n'
		dat_res.close()
	dat_index = dat_index[:-1]
	dat_index_f = open('../sim/imgindex.dat','w')
	dat_index_f.write(dat_index)
	dat_index_f.close()