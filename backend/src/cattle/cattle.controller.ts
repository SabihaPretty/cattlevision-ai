import { Body, Controller, Delete, Get, Param, Patch, Post } from '@nestjs/common';
import { CattleService } from './cattle.service';
import { CreateCattleDto } from './dto/create-cattle.dto';
import { UpdateCattleDto } from './dto/update-cattle.dto';

@Controller('cattle')
export class CattleController {
  constructor(private readonly cattleService: CattleService) {}

  @Get()
  async findAll() {
    const data = await this.cattleService.findAll();

    return {
      success: true,
      total: data.length,
      data,
    };
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return {
      success: true,
      data: await this.cattleService.findOne(id),
    };
  }

  @Post()
  async create(@Body() body: CreateCattleDto) {
    return {
      success: true,
      message: 'Cattle created successfully',
      data: await this.cattleService.create(body),
    };
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() body: UpdateCattleDto) {
    return {
      success: true,
      message: 'Cattle updated successfully',
      data: await this.cattleService.update(id, body),
    };
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return {
      success: true,
      message: 'Cattle deleted successfully',
      data: await this.cattleService.remove(id),
    };
  }
}