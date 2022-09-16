import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const UserId = createParamDecorator<number>((data: unknown, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest() as any;
  return request.user.sub;
});
