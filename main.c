#define ROW 25
#define COL 80
#define VGA_START 0xb8000
#define TASK_NUM  0x0a
typedef void (*start)(void);
struct task_struct{
	unsigned long *stacktop;
	long pid;
	start entry;
	struct ask_struct *next;
	long used;
	char name[5];
	unsigned long stack[1024];
}__attribute__((aligned(4)));

int TASK_SIZE = sizeof(struct task_struct);
struct task_struct  ts[TASK_NUM] = {0};
void context_switch(struct task_struct *current,struct task_struct *next);
void clear_screen(void){
	int row;
	int col;
	unsigned  short int *ptr = (unsigned short int *)VGA_START;
	for(row = 0; row < ROW;row ++){
		for(col = 0; col < COL;col++){
			ptr[row * ROW + col] = 0;
		}
	}
}


void put_char(char ch,char color,int row,int col){
	unsigned short int *ptr =  (unsigned short int *)VGA_START;
	ptr[row * COL + col] = ((unsigned short)color << 8) & 0xff00 | (unsigned short)ch;
}


void put_str(char *str, char color,int row ,int col){
	while(*str != '\0'){
		if(row == 25){
			row = 0;
		}
		if(col == 80){
			col = 0;
			row++;
		}
		put_char(*str++,color,row,col++);
	}
}
struct task_struct * task_create(start entry)
{
	struct task_struct *pts;
	struct task_struct *ret = (struct task_struct *) 0;
	for(pts = ts + 1; pts < &ts[TASK_NUM + 1]; pts++){
		if(pts->used == 0){
			ret = pts;
			ret->entry = entry;
			ret->stacktop = ret->stack;
			ret->stacktop +=1024;
			*(--(ret->stacktop)) = 0x08;
			*(--(ret->stacktop)) = (unsigned long)entry;
			*(--(ret->stacktop)) = (unsigned long)(&ret->stack[1023]); //ebp
		 	break;
		}
	}
	return ret;
}


struct task_struct *next_p;
struct task_struct *current_p;
void next_task(void)
{
	char *msg1 = "<<<<<<<<<<<<<<<<<<<";
	char *msg2 = "In next_task";
	put_str(msg1,0x07,3,4);
	put_str(msg2,0x07,4,4);
	put_str(msg1,0x07,5,4);
	
	context_switch(next_p,current_p);

	while(1);
}
int myMain(void){

	char *msg1 = ">>>>>>>>>>>>>>>>>>>";
	char *msg2 = "   Hello World !   ";
	clear_screen();
	put_str(msg1,0x07,0,4);
	put_str(msg2,0x07,1,4);
	put_str(msg1,0x07,2,4);
	
	current_p = &ts[0];
	next_p = task_create(&next_task);
	
	context_switch(current_p,next_p);

	put_str(msg1,0x07,6,4);
	put_str(msg2,0x07,7,4);
	put_str(msg1,0x07,8,4);
	while(1);
}
	

