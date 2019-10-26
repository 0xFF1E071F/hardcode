#ifndef FROMPLANE2COLOR_SCENE_HPP
#define FROMPLANE2COLOR_SCENE_HPP

#include "intiki_math.hpp"

using namespace tofu;
namespace mpl = boost::mpl;

typedef unsigned int uint;
typedef unsigned char uint8;

//#define min(x, y) ((x)<(y)?(x):(y))
//#define max(x, y) ((x)>(y)?(x):(y))

DECL_PS(init_x, DFXDVX*0.0f, DFXDVX*1.0f, DFXDVX*2.0f, DFXDVX*3.0f);
DECL_SS(delta_x, DFXDVX*4.0f);
DECL_SS(norm_width, NORM_WIDTH);
DECL_SS(norm_width_half, NORM_WIDTH*0.5f);
DECL_SS(norm_height, NORM_HEIGHT);
DECL_SS(norm_height_half, NORM_HEIGHT*0.5f);

#define FBUF_LOOP_BEGIN												\
	{																\
		uint c = 0;													\
		vec4 y = cps0;												\
																	\
		for(uint i=0; i<VIEW_HEIGHT; ++i, y += DFXDVX)				\
		{															\
			vec4 x = init_x;										\
			for(uint j=0; j<VIEW_WIDTH/4; ++j, ++c, x+=delta_x)		\

#define FBUF_LOOP_END												\
		}															\
	}																\

#define NUM_FPS	30

struct color
{
	vec4 r, g, b;

	__forceinline void gb(float v0)
	{
		g = b = v0;
	}

	__forceinline uvec4 to_uint() const
	{
		uvec4 ri(clamp(r, vec4::zero(), cps1)*255.0f);
		ri = _mm_slli_epi32(ri, 16);
		uvec4 gi(clamp(g, vec4::zero(), cps1)*255.0f);
		gi = _mm_slli_epi32(gi, 8);
		uvec4 bi(clamp(b, vec4::zero(), cps1)*255.0f);
		
		return ri | gi | bi;
	}
};

static color fbuffer[(VIEW_WIDTH/4)*VIEW_HEIGHT];

//���ۂɕ`�揈������֐���inline�W�J����ƈ�̑储�����Ȋ֐����ł���.
//�����Ȃ�ƃx�N�g���N���X�̃����o�֐���inline�W�J����Ȃ��Ȃ�
//�v���O�������x���Ȃ�, ���k��̃t�@�C���T�C�Y���傫���Ȃ�.
#define DRAW_FUNC_ATTRIB /*__forceinline*/

#include "scenes_simple.hpp"
#include "scenes_hinomaru.hpp"
#include "scenes_implicit_func.hpp"
#include "scenes_transform.hpp"

/*
�y���񂵂����̂Ńe���v���[�g�g���Ă܂��B
��̃V�[������̃N���X�ɂ���, �Đ��������V�[���̃N���X�̃��X�g��
mpl::vector�ɓZ�߂܂�.
*/
//concatenate all scenes into one type.
typedef
	mpl::vector
	<
		scenes_simple::scenes_simple_list,
		scenes::hinomaru::list,
		scenes::implicit::list,
		scenes::transform::list
	>
	scene_list_list;

/*
�S�ẴV�[���N���X�����������X�g(mpl::vector�e���v���[�g�N���X����������^)�B
�S�V�[���ɑ΂��ĉ�����������Ƃ��Ɏg���܂��B
*/
//This type(mpl::vector) is a list of all scenes.
//I use this type to do something with every scenes.
typedef
#if 1
	mpl::fold
	<
		scene_list_list,
		mpl::vector<>,
		mpl::copy<mpl::_2, mpl::back_inserter<mpl::_1> >
	>::type
#endif
	scene_list;

template<typename End>
__forceinline void select_scene
(
	uint, boost::type<End>, boost::type<End>
)
{
	ExitProcess(0);
}

template<typename Itr, typename End>
__forceinline void select_scene
(
	uint frameCount, boost::type<Itr>, boost::type<End>
)
{
	typedef mpl::deref<Itr>::type	s;

	if(frameCount < s::scene_length)
	{
		s::draw(frameCount);
		return;
	}

	select_scene
	(
		frameCount - s::scene_length,
		boost::type<mpl::next<Itr>::type>(),
		boost::type<End>()
	);
}

__forceinline void scene_manage(uint frameCount)
{
#if 0
	if(frameCount < SCENES_SIMPLE_SIMPLE_ANIM_FRAME_LEN)
	{
		scenes_simple::simple_anim(frameCount);
		return;
	}

	frameCount -= SCENES_SIMPLE_SIMPLE_ANIM_FRAME_LEN;

	if(frameCount < SCENES_SIMPLE_SIMPLE_ANIM_RED_FRAME_LEN)
	{
		scenes_simple::simple_anim_red(frameCount);
	}
#endif
	select_scene
	(
		frameCount,
		boost::type<mpl::begin<scene_list>::type>(),
		boost::type<mpl::end<scene_list>::type>()
	);
}

__forceinline void frame(uint frameCount)
{
	scene_manage(frameCount);

	for(uint i=0; i<(VIEW_WIDTH/4)*VIEW_HEIGHT; ++i)
	{
		pClrBuf[i] = fbuffer[i].to_uint();
	}
}

#endif
